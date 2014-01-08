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
#import "NSString+RSOHtmlDecodeAdditions.h"

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

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

- (RACSignal *)getTopQuestionsWithQuery:(NSString *)queryString
{
    RACSignal *signal = [[RSOWebServices sharedServices] fetchQuestionsWithQuery:queryString tag:nil];

    return [self questionsForSignal:signal];
}

- (RACSignal *)getTopiOSQuestionsWithQuery:(NSString *)queryString
{
    RACSignal *signal = [[RSOWebServices sharedServices] fetchQuestionsWithQuery:queryString tag:@"iOS"];
    
    return [self questionsForSignal:signal];
}

- (RACSignal *)getTopRubyQuestionsWithQuery:(NSString *)queryString
{
    RACSignal *signal = [[RSOWebServices sharedServices] fetchQuestionsWithQuery:queryString tag:@"Ruby"];
    
    return [self questionsForSignal:signal];
}

- (RACSignal *)getTopAndroidQuestionsWithQuery:(NSString *)queryString
{
    RACSignal *signal = [[RSOWebServices sharedServices] fetchQuestionsWithQuery:queryString tag:@"Android"];
    
    return [self questionsForSignal:signal];
}

- (RACSignal *)getTopWindowsQuestionsWithQuery:(NSString *)queryString
{
    RACSignal *signal = [[RSOWebServices sharedServices] fetchQuestionsWithQuery:queryString tag:@"Windows"];
    
    return [self questionsForSignal:signal];
}

- (RACSignal *)getQuestionData:(NSUInteger)questionID
{
    return [[[RSOWebServices sharedServices] fetchQuestionWithID:questionID] map:^(NSArray *questionDictionary) {
        return [RSOStore dictionaryToQuestion:[questionDictionary objectAtIndex:0]];
    }];
}

- (RACSignal *)questionsForSignal:(RACSignal *)signal
{
    return  [signal map:^(NSArray *questionDictionary) {
        NSMutableArray *questions = [[NSMutableArray alloc]init];
        for(id questionDictionaryItem in questionDictionary)
        {
            //            RSOQuestion *question = [RSOQuestion new];
            //            [question bnrSetValuesForKeysWithJSONDictionary:questionDictionaryItem];
            RSOQuestion *question = [RSOStore dictionaryToQuestion:questionDictionaryItem];
            [questions addObject:question];
        }
        
        return [questions copy];
    }];
}

#pragma mark - Data Transformers

+ (RSOQuestion *)dictionaryToQuestion:(NSDictionary *)questionDictionary
{
    if(!questionDictionary)
        return nil;
    
    RSOQuestion *question = [RSOQuestion new];
    NSNumber *questionID = questionDictionary[@"question_id"];
    question.postID = [questionID longValue];
    question.text = [questionDictionary[@"title"] rso_decodedStringForHtml];
    question.owner = [RSOStore dictionaryToOwner:questionDictionary[@"owner"]];
    
    NSMutableArray *answers = [[NSMutableArray alloc ]init];
    for (NSDictionary *answerDictionaryItem in questionDictionary[@"answers"])
    {
        RSOAnswer *answer = [RSOStore dictionaryToAnswer:answerDictionaryItem];
        answer.question = question;
        [answers addObject:answer];
    }
    
    question.answers = [answers copy];
    
    return question;
}

+ (RSOAnswer *)dictionaryToAnswer:(NSDictionary *)answerDictionary
{
    RSOAnswer *answer = [RSOAnswer new];
    NSNumber *answerID = answerDictionary[@"answer_id"];
    answer.postID = [answerID longValue];
    answer.text = [answerDictionary[@"body"] rso_decodedStringForHtml];
    answer.owner = [RSOStore dictionaryToOwner:answerDictionary[@"owner"]];
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
    comment.text = [commentDictionary[@"title"] rso_decodedStringForHtml];
    return comment;
}


@end
