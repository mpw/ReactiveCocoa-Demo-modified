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
#import <MPWFoundation/MPWFoundation.h>

@interface RSOStore : NSObject

+ (RSOStore*)sharedStore;
- (RACSignal *)topQuestions;
- (RACSignal *)topiOSQuestions;
- (RACSignal *)topAndroidQuestions;
- (RACSignal *)topWindowsQuestions;
- (RACSignal *)topRubyQuestions;
- (RACSignal *)getQuestionData:(NSUInteger)questionID;

-(void)sendFetchedQuestionsFor:(NSString*)tag to:(TargetBlock)target;


@end
