//
//  RSOQuestionCell.m
//  StackOverflow
//
//  Created by Howard Vining on 12/12/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOQuestionCell.h"

@implementation RSOQuestionCell

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

- (CGFloat) minimumHeightForCell:(NSString *)question
{
    CGSize size = [question sizeWithAttributes:@{NSFontAttributeName: self.questionTextLabel.font}];
    CGFloat labelWidth = self.questionTextLabel.frame.size.width;
    CGFloat actualHeight = size.height * ceil(size.width/ labelWidth);
    
    //Add some
    actualHeight += self.userTextLabel.frame.size.height + 53; // 53 for the 2 vertical spacing constraints and bottom space below the content view
    
    return actualHeight < 95 ? 95 : actualHeight ;
}

//- (CGFloat) minimumHeightForCell:(NSString *)question
//{
//    CGRect newRect = [question boundingRectWithSize:CGSizeMake(280, INFINITY)
//                                            options:NSStringDrawingUsesLineFragmentOrigin
//                                         attributes:@{NSFontAttributeName: self.questionTextLabel.font}
//                                            context:nil];
//    CGFloat actualHeight = newRect.size.height + 53;
//    NSLog(@"My Height:%f MY Width: %f", actualHeight < 95 ? 95 : actualHeight, newRect.size.width);
//    return actualHeight < 95 ? 95 : actualHeight ;
//}

@end
