//
//  TextFormItem.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/25/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "TextFormItem.h"

@implementation TextFormItem

#pragma mark - FormItemDisplay

- (BOOL)isValid {
    BOOL result = NO;
    NSString * value = [self getValue];
    if (self.optional) {
        if ([value length] == 0 || value == nil) {
            result = YES;
        } else {
            if (value.length < 10)
                result = YES;
            else result = NO;
        }
    }
    if (value.length < 10)
        result = YES;
    else result = NO;
    
    if (result)
        self.displayErrorMessage = NO;

    return result;
}

@end
