//
//  RSOAnswerCell.h
//  StackOverflow
//
//  Created by Howard Vining on 12/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTLabel;

@interface RSOAnswerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RTLabel *answerTextLabel;

- (CGFloat)minimumHeightForCell:(NSString *)answer;
@end
