//
//  RSORubyTableViewController.m
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSORubyTableViewController.h"
#import "RSOStore.h"
#import "RSOQuestion.h"
#import "RSOQuestionCell.h"
#import "RSOQuestionDetailViewController.h"
#import "MBProgressHUD.h"

@interface RSORubyTableViewController ()

@end

@implementation RSORubyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MBProgressHUD *progressOverlay = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressOverlay.mode = MBProgressHUDModeIndeterminate;
    progressOverlay.labelText = @"Downloading Hot Questions";
    progressOverlay.dimBackground = YES;
    progressOverlay.minSize = CGSizeMake(135.0f,135.0f);
    [progressOverlay show:YES];
    
    [[[[RSOStore sharedStore] getTopRubyQuestionsWithQuery:nil]
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *questions) {
         self.questions = [questions copy];
         [self.tableView reloadData];
         
         [progressOverlay hide:YES];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

#pragma mark - Table delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    RSOQuestion *question = [self.questions objectAtIndex:indexPath.row];
    RSOQuestionDetailViewController *detailViewController = [[RSOQuestionDetailViewController alloc] initWithQuestion:question];
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
