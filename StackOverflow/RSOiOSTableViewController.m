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

@interface RSOiOSTableViewController ()
@property (nonatomic) NSLayoutConstraint *topLayoutGuideConstraint;

@end

@implementation RSOiOSTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"iOS";
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
    
    [[[[RSOStore sharedStore] getTopiOSQuestionsWithQuery:nil]
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *questions) {
         self.questions = [questions copy];
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
    // Return the number of rows in the section.
    if(!self.questions)
        return 0;
    
    return [self.questions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    RSOQuestion *question = [self.questions objectAtIndex:indexPath.row];
    cell.textLabel.text = question.text;
    
    return cell;
}

@end
