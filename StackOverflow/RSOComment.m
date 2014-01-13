//
//  RSOComment.m
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOComment.h"
#import "NSString+RSOHtmlDecodeAdditions.h"

@implementation RSOComment

+ (RSOComment *)dictionaryToComment:(NSDictionary *)commentDictionary
{
    RSOComment *comment = [RSOComment new];
    comment.postID = (NSUInteger)commentDictionary[@"id"];
    comment.text = [commentDictionary[@"title"] rso_decodedStringForHtml];
    return comment;
}

@end
