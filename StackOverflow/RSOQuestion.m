//
//  RSOQuestion.m
//  StackOverflow
//
//  Created by Howard Vining on 10/31/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOQuestion.h"
#import "RSOAnswer.h"

#import "NSString+RSOHtmlDecodeAdditions.h"

@implementation RSOQuestion

+ (RSOQuestion *)questionForDictionary:(NSDictionary *)questionDictionary
{
    if(!questionDictionary)
        return nil;
    
    RSOQuestion *question = [RSOQuestion new];
    NSNumber *questionID = questionDictionary[@"question_id"];
    question.postID = [questionID longValue];
    question.text = [questionDictionary[@"title"] rso_decodedStringForHtml];
    question.owner = [RSOOwner ownerForDictionary:questionDictionary[@"owner"]];
    
    NSMutableArray *answers = [[NSMutableArray alloc ]init];
    for (NSDictionary *answerDictionaryItem in questionDictionary[@"answers"])
    {
        RSOAnswer *answer = [RSOAnswer answerForDictionary:answerDictionaryItem];
        answer.question = question;
        [answers addObject:answer];
    }
    
    question.answers = [answers copy];
    
    return question;
}

@end
