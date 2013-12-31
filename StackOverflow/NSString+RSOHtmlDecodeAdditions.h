//
//  NSString+RSOHtmlDecodeAdditions.h
//  StackOverflow
//
//  Created by Howard Vining on 12/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RSOHtmlDecodeAdditions)

- (NSString *)rso_decodedStringForHtml;

@end
