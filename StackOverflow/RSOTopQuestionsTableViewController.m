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

#import "UIControl+RACSignalSupport.h"

NSTimeInterval const kSearchQueryThrottle = .6;

@interface RSOTopQuestionsTableViewController ()
@property (strong, nonatomic) UITextField *searchBox;
@property (nonatomic, copy)NSArray *filteredTopQuestions;
@property (nonatomic) RACSignal *topQuestionsSignal;

@end

@implementation RSOTopQuestionsTableViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RSOStore *sharedStore = [RSOStore sharedStore] ;
    
    MBProgressHUD *progressOverlay = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressOverlay.mode = MBProgressHUDModeIndeterminate;
    progressOverlay.labelText = @"Downloading Hot Questions";
    progressOverlay.dimBackground = YES;
    progressOverlay.minSize = CGSizeMake(135.0f,135.0f);
    [progressOverlay show:YES];
    
    //Setup table view control
    //Running reloadData on table from background thread causes substantial latency to loading table cells
    //so use mainThreadScheduler to run the update on the main UI thread
    self.topQuestionsSignal = [[sharedStore topQuestions] deliverOn:[RACScheduler mainThreadScheduler]];
    [self.topQuestionsSignal subscribeNext:^(NSArray *questions) {
         [self loadquestions:questions];
     } error:^(NSError *error) {
         [self displayError:@"Could not load data" title:@"An error occurred"];
         [progressOverlay hide:YES];
     } completed:^{
         [progressOverlay hide:YES afterDelay:1];
     }];
    
    //Setup refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [[refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UIRefreshControl *refreshControl) {
        [self.topQuestionsSignal subscribeNext:^(NSArray *questions) {
            [self loadquestions:questions];
        } error:^(NSError *error) {
            [self displayError:@"Could not load data" title:@"An error occurred"];
            [refreshControl endRefreshing];
        } completed:^{
            [refreshControl endRefreshing];
        }];
    }];
    self.refreshControl = refreshControl;
    
    //Setup search text box
    self.searchBox = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, 280, 30)];
    self.searchBox.placeholder = @"Search";
    [self.searchBox setBorderStyle:UITextBorderStyleRoundedRect];
    self.searchBox.delegate = self;
    [[[self.searchBox.rac_textSignal throttle:kSearchQueryThrottle] skip:1] subscribeNext:^(NSString *queryString) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSOQuestion *question = [self.questions objectAtIndex:indexPath.row];
    RSOQuestionDetailViewController *detailViewController = [[RSOQuestionDetailViewController alloc] initWithQuestion:question];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self.searchBox resignFirstResponder];
}

#pragma mark - Helpers
- (void)loadquestions:(NSArray *)questions
{
    self.questions = questions;
    self.filteredTopQuestions = [questions copy];
    [self.tableView reloadData];
}

- (void)displayError:(NSString *)message title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

@end
