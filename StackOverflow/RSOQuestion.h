//
//  RSOQuestion.h
//  StackOverflow
//
//  Created by Howard Vining on 10/31/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOPost.h"

@class RSOAnswer;

@interface RSOQuestion : RSOPost
@property (nonatomic) BOOL hasAcceptedAnswer;
@property (nonatomic, copy) NSArray *answers;
@property (nonatomic, copy) NSArray *comments;
@property (nonatomic, weak) RSOAnswer *acceptedAnswer;

+ (RSOQuestion *)questionForDictionary:(NSDictionary *)questionDictionary;

@end


