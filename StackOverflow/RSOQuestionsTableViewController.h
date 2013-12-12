//
//  RSOQuestionsTableViewController.h
//  StackOverflow
//
//  Created by Howard Vining on 11/27/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const cellIdentifier;

@interface RSOQuestionsTableViewController : UITableViewController
@property (nonatomic) NSArray *questions;

@end
