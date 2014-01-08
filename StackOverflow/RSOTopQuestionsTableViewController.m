//
//  RSOTopQuestionsTableViewController.m
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOTopQuestionsTableViewController.h"
#import "RSOWebServices.h"
#import "ReactiveCocoa.h"
#import "RSOStore.h"
#import "RSOQuestion.h"
#import "RSOQuestionDetailViewController.h"
#import "RACSignal+Operations.h"
#import "RACScheduler.h"
#import "RSOQuestionCell.h"
#import "MBProgressHUD.h"

double const RSOConstantsSearchQueryThrottle = .6;

@interface RSOTopQuestionsTableViewController ()
@property (strong, nonatomic) UITextField *searchBox;
@property (nonatomic, copy)NSArray *filteredTopQuestions;

@end

@implementation RSOTopQuestionsTableViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBox = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, 280, 30)];
    self.searchBox.placeholder = @"Search";
    [self.searchBox setBorderStyle:UITextBorderStyleRoundedRect];
    self.searchBox.delegate = self;
    
    [[[self.searchBox.rac_textSignal throttle:RSOConstantsSearchQueryThrottle] skip:1] subscribeNext:^(NSString *queryString) {
        //Update Top questions table
        if(queryString && ![queryString isEqualToString:@""])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text contains[c] %@", queryString];
            self.filteredTopQuestions = [self.questions filteredArrayUsingPredicate:predicate];
        }
        else
        {
            self.filteredTopQuestions = [self.questions copy];
        }
        [self.tableView reloadData];
    }];
    
    RSOStore *sharedStore = [RSOStore sharedStore] ;
    
    //Running reloadData on table from background thread causes substantial latency to loading table cells
    //so use mainThreadScheduler to run the update on the main UI thread
    
    MBProgressHUD *progressOverlay = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressOverlay.mode = MBProgressHUDModeIndeterminate;
    progressOverlay.labelText = @"Downloading Hot Questions";
    progressOverlay.dimBackground = YES;
    progressOverlay.minSize = CGSizeMake(135.0f,135.0f);
    [progressOverlay show:YES];
    
    RACSignal *topQuestionsSignal = [sharedStore getTopQuestionsWithQuery:nil];
    [[topQuestionsSignal
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSArray *questions) {
        self.questions = questions;
        self.filteredTopQuestions = [questions copy];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"Could not load data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([self.filteredTopQuestions count])
        return [self.filteredTopQuestions count];
    else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:self.searchBox];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
    
    RSOQuestion *question = [self.filteredTopQuestions objectAtIndex:indexPath.row];
    cell.questionTextLabel.text = question.text;
    cell.userTextLabel.text = question.owner.screenName;
    
    return cell;
}

#pragma mark - Table view delegate

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

#pragma mark - textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self.searchBox resignFirstResponder];
}

@end
