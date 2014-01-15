//
//  RSOiOSTableViewController.m
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOiOSTableViewController.h"
#import "RSOStore.h"
#import "RSOQuestion.h"
#import "RSOQuestionCell.h"
#import "RSOQuestionDetailViewController.h"
#import "MBProgressHUD.h"

@implementation RSOiOSTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MBProgressHUD *progressOverlay = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressOverlay.mode = MBProgressHUDModeIndeterminate;
    progressOverlay.labelText = @"Downloading iOS Questions";
    progressOverlay.dimBackground = YES;
    progressOverlay.minSize = CGSizeMake(135.0f,135.0f);
    [progressOverlay show:YES];
    
    [[[[RSOStore sharedStore] topiOSQuestions] deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(NSArray *questions) {
         self.questions = [questions copy];
         [self.tableView reloadData];
     } error:^(NSError *error) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred"
                                                         message:@"Could not load data"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
         [alert show];
         [progressOverlay hide:YES];
     } completed:^{
         [progressOverlay hide:YES afterDelay:1];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(!self.questions)
        return 0;
    
    return [self.questions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSOQuestionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    RSOQuestion *question = [self.questions objectAtIndex:indexPath.row];
    CGFloat height = [cell minimumHeightForCell:question.text];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSOQuestionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    RSOQuestion *question = [self.questions objectAtIndex:indexPath.row];
    cell.questionTextLabel.text = question.text;
    cell.userTextLabel.text = question.owner.screenName;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSOQuestion *question = [self.questions objectAtIndex:indexPath.row];
    RSOQuestionDetailViewController *detailViewController = [[RSOQuestionDetailViewController alloc] initWithQuestion:question];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
