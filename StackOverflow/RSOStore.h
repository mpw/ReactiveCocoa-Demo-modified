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

+ (RSOStore*)sharedStore;

- (RACSignal *)getTopQuestionsWithQuery:(NSString *)queryString;

- (RACSignal *)getQuestionData:(NSUInteger)questionID;

@end
