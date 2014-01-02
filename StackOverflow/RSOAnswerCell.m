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
    NSString *refinedAnswerText = self.answerTextLabel.plainText;
    CGRect newRect = [refinedAnswerText boundingRectWithSize:CGSizeMake(320, INFINITY)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName: self.answerTextLabel.font}
                                                     context:nil];
    CGFloat actualHeight = newRect.size.height;
    
    //Add some
    actualHeight += 53;
    
    return actualHeight < 95 ? 95 : actualHeight ;
}

@end
