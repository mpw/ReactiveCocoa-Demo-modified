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
#import "RSOAnswer.h"
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
    return [[[RSOWebServices sharedServices] fetchQuestionWithID:questionID] map:^(NSArray *questionsArray) {
        return [RSOQuestion questionForDictionary:[questionsArray objectAtIndex:0]];
    }];
}

- (RACSignal *)questionsForSignal:(RACSignal *)signal
{
    return  [signal map:^(NSArray *questionsArray) {
        NSMutableArray *questions = [[NSMutableArray alloc]init];
        for(NSDictionary *questionDictionaryItem in questionsArray)
        {
            RSOQuestion *question = [RSOQuestion questionForDictionary:questionDictionaryItem];
            [questions addObject:question];
        }
        
        return [questions copy];
    }];
}

@end
