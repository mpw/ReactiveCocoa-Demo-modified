//
//  RSOStore.h
//  StackOverflow
//
//  Created by Howard Vining on 10/31/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOQuestion.h"
#import "ReactiveCocoa.h"

@interface RSOStore : NSObject

@property (nonatomic, copy) NSArray *topQuestions;

+ (RSOStore*)sharedStore;

+ (void)startPrepareStore;

- (RACSignal *)getQuestionData:(NSUInteger)questionID;

@end
