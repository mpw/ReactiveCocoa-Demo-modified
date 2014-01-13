//
//  RSOAnswer.h
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//


#import "RSOPost.h"

@class RSOQuestion;

@interface RSOAnswer : RSOPost

@property (nonatomic, weak) RSOQuestion *question;

+ (RSOAnswer *)answerForDictionary:(NSDictionary *)answerDictionary;

@end
