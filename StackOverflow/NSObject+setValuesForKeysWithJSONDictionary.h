//
//  NSObject+setValuesForKeysWithJSONDictionary.h
//  SafeSetDemo
//
//  Created by Tom Harrington on 12/29/11.
//  Copyright (c) 2011 Atomic Bird, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


// A *much* safer version of setValuesForKeysWithDictionary - we won't crash if the
// web service adds a new field.

@interface NSObject (bnrSetValuesForKeysWithJSONDictionary)

- (void)bnrSetValuesForKeysWithJSONDictionary:(NSDictionary *)keyedValues;

- (void)bnrSetValuesForKeysWithJSONDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter;

@end
