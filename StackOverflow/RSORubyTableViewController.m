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
#import "RSOQuestionCell.h"
#import "RSOQuestionDetailViewController.h"
#import "MBProgressHUD.h"
#import "RACEXTScope.h"
#import <MPWFoundation/MPWFoundation.h>


@interface RSORubyTableViewController ()


@end

@implementation RSORubyTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureViewForQuestions:@"Ruby" label:@"Loading top Ruby questions"];
}


@end
