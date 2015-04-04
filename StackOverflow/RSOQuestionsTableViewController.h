//
//  RSOQuestionsTableViewController.h
//  StackOverflow
//
//  Created by Howard Vining on 11/27/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const cellIdentifier;

@class MPWStream;

@interface RSOQuestionsTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) MPWStream *questionsStream;

-(void)configureViewForQuestions:(NSString*)questionTag label:(NSString*)questionsLabel;

@end
