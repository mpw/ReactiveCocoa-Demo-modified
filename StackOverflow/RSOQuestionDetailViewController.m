//
//  RSOQuestionDetailViewController.m
//  StackOverflow
//
//  Created by Howard Vining on 11/13/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOQuestionDetailViewController.h"
#import "RSOQuestion.h"
#import "RSOAnswer.h"
#import "RSOStore.h"
#import "ReactiveCocoa.h"

typedef NS_ENUM(int16_t, RSOQuestionDetailRowType)
{
    RSOQuestionDetailQuestionRowType = 0,
    RSOQuestionDetailAnswer
};

@interface RSOQuestionDetailViewController ()
@property (strong, nonatomic) RSOQuestion *question;
@end

@implementation RSOQuestionDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithQuestion:(RSOQuestion *)question
{
    self = [super init];
    if(self)
    {
        _question = question;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setAllowsSelection:NO];
    [[[RSOStore sharedStore] getQuestionData:self.question.postID] subscribeNext:^(RSOQuestion *question) {
        self.question.answers = question.answers;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == RSOQuestionDetailQuestionRowType)
        return 100;

    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(!self.question.answers)
        return 1;
    
    return [self.question.answers count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if(indexPath.row == RSOQuestionDetailQuestionRowType)
    {
        cell.textLabel.text = self.question.text;
    }else
    {
        RSOAnswer *answer = [self.question.answers objectAtIndex:indexPath.row -1];
        cell.textLabel.text = answer.text;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

@end
