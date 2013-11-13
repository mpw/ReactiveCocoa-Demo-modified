//
//  RSOQuestionDetailViewController.h
//  StackOverflow
//
//  Created by Howard Vining on 11/13/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSOQuestion;

@interface RSOQuestionDetailViewController : UITableViewController

- (id)initWithQuestion:(RSOQuestion *)question;

@end
