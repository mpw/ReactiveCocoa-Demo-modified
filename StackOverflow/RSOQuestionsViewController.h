//
//  RSOQuestionsViewController.h
//  StackOverflow
//
//  Created by Howard Vining on 11/27/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSOQuestionsViewController : UITableViewController
@property (nonatomic) NSArray *questions;
@property (nonatomic) IBOutlet NSLayoutConstraint *topLayoutGuide;

@end
