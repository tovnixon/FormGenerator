//
//  BaseFormItem.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/11/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormItemProtocol.h"
//  keys should be same as in the target JSON
static NSString * formItemSerializationKeyType = @"type";
static NSString * formItemSerializationKeyName = @"name";
static NSString * formItemSerializationKeyLabel = @"label";
static NSString * formItemSerializationKeyReadonly = @"isReadOnly";
static NSString * formItemSerializationKeyDefaultValue = @"defaultValue";
static NSString * formItemSerializationKeyDescription = @"description";
static NSString * formItemSerializationKeyValidation = @"pattern";
static NSString * formItemSerializationKeyHelpText = @"helpText";
static NSString * formItemSerializationKeyMaxLength = @"maxLength";
static NSString * formItemSerializationKeySelectionOptions = @"enums";
static NSString * formItemSerializationKeySubItems = @"fields";

//  keys presenting actual class properties, can be used via KVC
static NSString * formItemPropertyKeyType = @"type";
static NSString * formItemPropertyKeyName = @"name";
static NSString * formItemPropertyKeyLabel = @"label";
static NSString * formItemPropertyKeyReadonly = @"readonly";
static NSString * formItemPropertyKeyDefaultValue = @"defaultValue";
static NSString * formItemPropertyKeyDescription = @"itemDescription";
static NSString * formItemPropertyKeyValidation = @"validationPattern";
static NSString * formItemPropertyKeyHelpText = @"helpText";
static NSString * formItemPropertyKeyMaxLength = @"maxLength";
static NSString * formItemPropertyKeySelectionOptions = @"selectionOptions";
static NSString * formItemPropertyKeySubItems = @"subItems";

@interface BaseFormItem : NSObject <FormItemProtocol>

@end
