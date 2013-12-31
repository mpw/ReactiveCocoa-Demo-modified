//
//  NSString+RSOHtmlDecodeAdditions.m
//  StackOverflow
//
//  Created by Howard Vining on 12/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "NSString+RSOHtmlDecodeAdditions.h"

@implementation NSString (RSOHtmlDecodeAdditions)

 - (NSString *)rso_decodedStringForHtml
{
    NSString *decodedString = [self stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    return decodedString;
}

@end
