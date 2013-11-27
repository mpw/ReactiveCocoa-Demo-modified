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

@class RACSignal;

@interface RSOWebServices : NSObject<NSURLSessionDataDelegate>

+ (RSOWebServices *) sharedServices;

- (RACSignal *)fetchQuestionsWithQuery:(NSString *)query tag:(NSString *)tag;

- (RACSignal *)fetchQuestionWithID:(NSUInteger)questionID;

- (void)fetchAnswerWithId:(NSUInteger) answerID completion:(void(^)(NSArray *answer, NSError *error))completion;

- (void)fetchCommentWithId:(NSUInteger) commentID completion:(void(^)(RSOComment *comment, NSError *error))completion;

@end
