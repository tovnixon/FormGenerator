//
//  SelectFormItem.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/23/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "BaseFormItem.h"
#import "FormItemOption.h"
#import "SelectFormItemProtocol.h"
static NSString * formItemSerializationKeyEnumOptions = @"enums";
static NSString * formItemSerializationKeyLabelOptions = @"labels";

static NSString * formItemPropertyKeySelectionOptions = @"options";

@interface SelectFormItem : BaseFormItem <SelectFormItemProtocol>

@end
