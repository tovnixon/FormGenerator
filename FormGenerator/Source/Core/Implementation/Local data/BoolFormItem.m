//
//  BoolFormItem.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/25/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "BoolFormItem.h"

@implementation BoolFormItem

#pragma mark - FormItemDisplay
- (id)getValue {
    if (self.storedValue) {
        return self.storedValue;
    } else if (self.defaultValue) {
        return self.defaultValue;
    }
    return nil;
}

- (BOOL)isValid {
    if ([self getValue] == nil)
        return NO;
    return YES;
}

- (void)setValue:(id)aValue {
    self.storedValue = aValue;
}

@end
