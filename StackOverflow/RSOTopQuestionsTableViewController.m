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
#import "RSOConstants.h"
#import "RACScheduler.h"

@interface RSOTopQuestionsTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchBox;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutGuideConstraint;
@property (nonatomic, copy) NSArray *topQuestions;
@property (nonatomic, copy)NSArray *filteredTopQuestions;

@end

@implementation RSOTopQuestionsTableViewController

- (id)init{
    self = [super init];
    if(self)
    {
        self.tabBarItem.title = @"Top Questions";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([self respondsToSelector:@selector(topLayoutGuide)])
    {
        self.topLayoutGuideConstraint.constant = 20;
    }
    
    self.searchBox.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [[[self.searchBox.rac_textSignal throttle:RSOConstantsSearchQueryThrottle] skip:1] subscribeNext:^(NSString *queryString) {
        //Update Top questions table
        if(queryString && ![queryString isEqualToString:@""])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text contains[c] %@", queryString];
            self.filteredTopQuestions = [self.topQuestions filteredArrayUsingPredicate:predicate];
        }
        else
        {
            self.filteredTopQuestions = [self.topQuestions copy];
        }
        [self.tableView reloadData];
    }];
    
    RSOStore *sharedStore = [RSOStore sharedStore] ;
    RACSignal *topQuestionsSignal = [sharedStore getTopQuestionsWithQuery:nil];
    [topQuestionsSignal subscribeNext:^(NSArray *questions) {
        self.topQuestions = questions;
        self.filteredTopQuestions = [questions copy];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if([self.filteredTopQuestions count])
    {
        RSOQuestion *question = [self.filteredTopQuestions objectAtIndex:indexPath.row];
        cell.textLabel.text = question.text;
    }
    
    NSLog(@"Created Cell - %d, %@", indexPath.row, [NSDate date]);
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    RSOQuestion *question = [self.topQuestions objectAtIndex:indexPath.row];
    RSOQuestionDetailViewController *detailViewController = [[RSOQuestionDetailViewController alloc] initWithQuestion:question];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.tabBarController.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self.searchBox resignFirstResponder];
}

@end
