//
//  RSOAnswerCell.m
//  StackOverflow
//
//  Created by Howard Vining on 12/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOAnswerCell.h"
#import "RTLabel.h"

@implementation RSOAnswerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat) minimumHeightForCell:(NSString *)answer
{
    [self.answerTextLabel setText:answer];
    NSString *refinedAnswerText = self.answerTextLabel.text;
    CGSize size = [refinedAnswerText sizeWithAttributes:@{NSFontAttributeName: self.answerTextLabel.font}];
    CGFloat labelWidth = self.answerTextLabel.frame.size.width;
    CGFloat actualHeight = size.height * ceil(size.width/ labelWidth);
    
    //Add some
    actualHeight += 20; // 20 for the vertical spacing constraint
    
    return actualHeight < 95 ? 95 : actualHeight ;
}

@end
