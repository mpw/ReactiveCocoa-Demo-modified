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

@interface RSOTopQuestionsTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchBox;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    // Uncomment the following line to preserve selection between presentations.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [RACObserve([RSOStore sharedStore], topQuestions) subscribeNext:^(NSArray *questions) {
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
    return [[RSOStore sharedStore].topQuestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    RSOQuestion *question = [[RSOStore sharedStore].topQuestions objectAtIndex:indexPath.row];
    cell.textLabel.text = question.text;
    
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
    RSOQuestion *question = [[RSOStore sharedStore].topQuestions objectAtIndex:indexPath.row];
    RSOQuestionDetailViewController *detailViewController = [[RSOQuestionDetailViewController alloc] initWithQuestion:question];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
