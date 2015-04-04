//
//  RSOQuestionsTableViewController.m
//  StackOverflow
//
//  Created by Howard Vining on 11/27/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOQuestionsTableViewController.h"
#import "RSOQuestionCell.h"
#import "MBProgressHUD.h"
#import "RACEXTScope.h"
#import "RSOStore.h"
#import "RSOQuestionDetailViewController.h"
#import "RSOWebServices.h"

NSString * const cellIdentifier = @"QuestionCellIdentifier";

@interface RSOQuestionsTableViewController ()

@end

@implementation RSOQuestionsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([RSOQuestionCell class])bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    [self reloadQuestions];
    
}

-(void)reloadQuestions
{
    NSString *cat=[self category];
    NSString *message=[NSString stringWithFormat:@"Loading %@ questions",[cat length]==0? @"Top" : cat];
    [self configureViewForQuestions:cat label:message];

}

-(void)configureViewForQuestions:(NSString*)questionTag label:(NSString*)questionsLabel
{
    [super viewDidLoad];
    __block BOOL showing = NO;
    
    
    
    MBProgressHUD *progressOverlay = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressOverlay.mode = MBProgressHUDModeIndeterminate;
    progressOverlay.labelText = questionsLabel;
    progressOverlay.dimBackground = YES;
    progressOverlay.minSize = CGSizeMake(135.0f,135.0f);
    [progressOverlay show:YES];
    showing=YES;
    
    [self setQuestions:[NSMutableArray array]];
    
//    
//    @weakify(self);
//    [[[[RSOStore sharedStore] topRubyQuestions] deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(NSArray *questions) {
//        @strongify(self);
//        self.questions = [questions copy];
//        [self.tableView reloadData];
//    } error:^(NSError *error) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred"
//                                                        message:@"Could not load data"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles: nil];
//        [alert show];
//        [self.progressOverlay hide:YES];
//    } completed:^{
//        [self.progressOverlay hide:YES afterDelay:1];
//    }];

    @weakify(self);
    [[RSOStore sharedStore] sendFetchedQuestionsFor:questionTag to:^(id newQuestion){
        @strongify(self)
        if (newQuestion) {
            [(NSMutableArray*)self.questions addObject:newQuestion];
        }
        if ( showing ) {
            [progressOverlay hide:YES afterDelay:1];
            showing=NO;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSOQuestion *question = [self.questions objectAtIndex:indexPath.row];
    RSOQuestionDetailViewController *detailViewController = [[RSOQuestionDetailViewController alloc] initWithQuestion:question];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
