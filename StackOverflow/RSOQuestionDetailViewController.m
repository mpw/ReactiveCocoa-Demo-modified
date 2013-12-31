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
#import "RSOOwner.h"
#import "RSOStore.h"
#import "ReactiveCocoa.h"
#import "RSOQuestionCell.h"
#import "RSOAnswerCell.h"
#import "RTLabel.h"

static NSString *const answerCellIdentifier = @"RSOAnswerCellIdentifier";
static NSString *const questionCellIdentifier = @"RSOQuestionCellIdentifier";

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
    
    UINib *questionCellNib = [UINib nibWithNibName:@"RSOQuestionCell" bundle:nil];
    [self.tableView registerNib:questionCellNib forCellReuseIdentifier:questionCellIdentifier];
    
    UINib *answerCellNib = [UINib nibWithNibName:@"RSOAnswerCell" bundle:nil];
    [self.tableView registerNib:answerCellNib forCellReuseIdentifier:answerCellIdentifier];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    RSOQuestionCell *questionCell = (RSOQuestionCell *)[self.tableView dequeueReusableCellWithIdentifier:questionCellIdentifier];
    CGFloat height = [questionCell minimumHeightForCell:self.question.text];
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    RSOQuestionCell *questionCell = (RSOQuestionCell *)[self.tableView dequeueReusableCellWithIdentifier:questionCellIdentifier];
    [questionCell.questionTextLabel setText:self.question.text];
    [questionCell.userTextLabel setText:self.question.owner.screenName];
    [questionCell setBackgroundColor:[UIColor whiteColor]];
    return questionCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSOAnswerCell *answerCell = [self.tableView dequeueReusableCellWithIdentifier:answerCellIdentifier];
    RSOAnswer *answer = [self.question.answers objectAtIndex:indexPath.row];
    CGFloat height = [answerCell minimumHeightForCell:answer.text];
    return height;
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
        return 0;
    
    return [self.question.answers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSOAnswer *answer = [self.question.answers objectAtIndex:indexPath.row];
    RSOAnswerCell *answerCell = (RSOAnswerCell *)[self.tableView dequeueReusableCellWithIdentifier:answerCellIdentifier forIndexPath:indexPath];
    [answerCell.answerTextLabel setText:answer.text];
    return answerCell;
}

@end
