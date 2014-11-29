//
//  FormItemTypes2Classes.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/23/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "FormItemTypes2Classes.h"
#import "BaseFormItem.h"
#import "SelectFormItem.h"
#import "GroupFormItem.h"
#import "BoolFormItem.h"
#import "TextFormItem.h"
#import "LabelFormItem.h"
@implementation FormItemTypes2Classes
+ (FormItemTypes2Classes *)sharedInstance {
    static FormItemTypes2Classes * instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [FormItemTypes2Classes new];
    });
    return instance;
}

- (Class)formItemClassByType:(NSString *)formItemType {
    if ([formItemType isEqualToString:FormItemTypeSingleSelection]) {
        return [SelectFormItem class];
    } else if ([formItemType isEqualToString:FormItemTypeNestedGroup]) {
        return [GroupFormItem class];
    } else if ([formItemType isEqualToString:FormItemTypeCheckBox]) {
        return [BoolFormItem class];
    } else if ([formItemType isEqualToString:FormItemTypeText]) {
        return [TextFormItem class];
    } else if ([formItemType isEqualToString:FormItemTypeLabel]) {
        return [LabelFormItem class];
    }
    else {
        return [BaseFormItem class];
    }
}

@end
