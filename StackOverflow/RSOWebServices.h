//
//  RSOWebServices.h
//  StackOverflow
//
//  Created by Howard Vining on 10/31/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOAnswer.h"
#import "RSOQuestion.h"
#import "RSOComment.h"
#import <MPWFoundation/MPWFoundation.h>

@class RACSignal;

@interface RSOWebServices : NSObject<NSURLSessionDataDelegate>

+ (RSOWebServices *)sharedServices;

- (RACSignal *)fetchQuestionsWithTag:(NSString *)tag;

- (RACSignal *)fetchQuestionWithID:(NSUInteger)questionID;

-(void)sendFetchedQuestionsFor:(NSString*)tag to:(TargetBlock)target;
-(MPWStream*)streamSendingTo:(TargetBlock)target;

@end
