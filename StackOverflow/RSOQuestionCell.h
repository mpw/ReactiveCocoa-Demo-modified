//
//  RSOQuestionCell.h
//  StackOverflow
//
//  Created by Howard Vining on 12/12/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSOQuestionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTextLabel;

- (CGFloat)minimumHeightForCell:(NSString *)question;

@end
