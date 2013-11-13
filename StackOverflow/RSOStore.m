//
//  RSOStore.m
//  StackOverflow
//
//  Created by Howard Vining on 10/31/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOStore.h"
#import "RSOWebServices.h"
#import "ReactiveCocoa.h"
#import "RSOQuestion.h"
#import "RSOComment.h"
#import "NSObject+setValuesForKeysWithJSONDictionary.h"

@interface RSOStore ()
@end

@implementation RSOStore

+ (RSOStore *)sharedStore
{
    static RSOStore *sharedStore = nil;
    if(!sharedStore)
    {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

+ (void)startPrepareStore
{
    RSOStore *store = [self sharedStore];
    
    [store getTopQuestionsWithCompletion:^(NSArray *topQuestions, NSError *error) {
        if(!error)
            store.topQuestions = topQuestions;
    }];
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

- (void)getTopQuestionsWithCompletion:(void (^) (NSArray *topQuestions, NSError *error))completion
{
    [[[RSOWebServices sharedServices] fetchQuestionsWithQuery:nil] subscribeNext:^(NSDictionary *questionDictionary) {
        NSMutableArray *questions = [[NSMutableArray alloc]init];
        for(id questionDictionaryItem in questionDictionary)
        {
//            RSOQuestion *question = [RSOQuestion new];
//            [question bnrSetValuesForKeysWithJSONDictionary:questionDictionaryItem];
            RSOQuestion *question = [RSOStore dictionaryToQuestion:questionDictionaryItem];
            [questions addObject:question];
        }
        _topQuestions = [questions copy];
        
        if(completion)
            completion(_topQuestions, nil);
    }];
}

- (RACSignal *)getQuestionData:(NSUInteger)questionID
{
    return [[[RSOWebServices sharedServices] fetchQuestionWithID:questionID] map:^(NSDictionary *questionDictionary) {
        return [RSOStore dictionaryToQuestion:questionDictionary];
    }];
}

+ (RSOQuestion *)dictionaryToQuestion:(NSDictionary *)questionDictionary
{
    RSOQuestion *question = [RSOQuestion new];
    question.postID = (NSUInteger)questionDictionary[@"id"];
    question.text = questionDictionary[@"title"];
    question.owner = [RSOStore dictionaryToOwner:questionDictionary[@"owner"]];
    
    NSMutableArray *answers = [[NSMutableArray alloc ]init];
    for (NSDictionary *answerDictionaryItem in questionDictionary[@"answers"])
    {
        [answers addObject:[RSOStore dictionaryToAnswer:answerDictionaryItem]];
    }
    
//    question.answers = [answers copy];
    
    return question;
}

+ (RSOAnswer *)dictionaryToAnswer:(NSDictionary *)answerDictionary
{
    RSOAnswer *answer = [RSOAnswer new];
    answer.postID = (NSUInteger)answerDictionary[@"id"];
    answer.text = answerDictionary[@"body"];
    return answer;
}

+ (RSOOwner *)dictionaryToOwner:(NSDictionary *)ownerDictionary
{
    RSOOwner *owner = [RSOOwner new];
    owner.screenName = ownerDictionary[@"display_name"];
    return owner;
}

+ (RSOComment *)dictionaryToComment:(NSDictionary *)commentDictionary
{
    RSOComment *comment = [RSOComment new];
    comment.postID = (NSUInteger)commentDictionary[@"id"];
    comment.text = commentDictionary[@"title"];
    return comment;
}


@end
