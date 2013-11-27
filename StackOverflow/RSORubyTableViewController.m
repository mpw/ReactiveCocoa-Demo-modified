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

@interface RSORubyTableViewController ()

@end

@implementation RSORubyTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Ruby";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[[RSOStore sharedStore] getTopRubyQuestionsWithQuery:nil]
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    
    RSOQuestion * question = [self.questions objectAtIndex:indexPath.row];
    cell.textLabel.text = question.text;
    
    return cell;
}

@end
