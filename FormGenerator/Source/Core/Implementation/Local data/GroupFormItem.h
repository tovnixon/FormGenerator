//
//  GroupFormItem.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/24/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "BaseFormItem.h"
#import "GroupFormItemProtocol.h"
static NSString * formItemPropertyKeySubItems = @"subItems";
static NSString * formItemSerializationKeySubItems = @"fields";

@interface GroupFormItem : BaseFormItem <GroupFormItemProtocol>

@end
