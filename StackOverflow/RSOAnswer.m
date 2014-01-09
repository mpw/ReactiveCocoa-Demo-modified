//
//  RSOAnswer.m
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOAnswer.h"
#import "RSOOwner.h"

#import "NSString+RSOHtmlDecodeAdditions.h"

@implementation RSOAnswer

+ (RSOAnswer *)answerForDictionary:(NSDictionary *)answerDictionary
{
    RSOAnswer *answer = [RSOAnswer new];
    NSNumber *answerID = answerDictionary[@"answer_id"];
    answer.postID = [answerID longValue];
    answer.text = [answerDictionary[@"body"] rso_decodedStringForHtml];
    answer.owner = [RSOOwner ownerForDictionary:answerDictionary[@"owner"]];
    return answer;
}

@end
