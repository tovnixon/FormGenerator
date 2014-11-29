//
//  SelectFormItem.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/23/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "SelectFormItem.h"
#import "BaseFormItem+Protected.h"
@implementation SelectFormItem
@synthesize maping;
@synthesize options;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self.maping addObject:[MappingPair pairKey:formItemSerializationKeyEnumOptions to:formItemPropertyKeySelectionOptions]];
        [self.maping addObject:[MappingPair pairKey:formItemSerializationKeyLabelOptions to:formItemPropertyKeySelectionOptions]];
        if (dictionary)
            [self serializeFromDictionary:dictionary];
        [self createBindingKey];
    }
    return self;
}

- (void)serializeFromDictionary:(NSDictionary *)dictionary {
    NSArray * enums = nil;
    NSArray * labels = nil;
    for (MappingPair * mp in self.maping) {
        id val = [dictionary objectForKey:mp.keyFrom];
        if (val) {
            if ([mp.keyFrom isEqualToString:formItemSerializationKeyEnumOptions]) {
                enums = val;
            } else if ([mp.keyFrom isEqualToString:formItemSerializationKeyLabelOptions]) {
                labels = val;
            } else {
                [self setValue:val forKey:mp.keyTo];
            }
        }
    }
    NSMutableArray * _options = [@[] mutableCopy];
    //join enums and labels in unit
    int i = 0;//suppose both array have same length
    for (NSString * label in labels) {
        SelectFormItem * fi = [FormItemOption optionWithTitle:label value:enums[i]];
        [_options addObject:fi];
        i++;
    }
    [self setValue:_options forKey:formItemPropertyKeySelectionOptions];
}

- (DDXMLNode *)xmlElement {
    FormItemOption * value = self.storedValue ? self.storedValue : self.defaultValue;
    if (value) {
        return [DDXMLNode elementWithName:self.name stringValue:value.title];
    }
    else
        return nil;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"SelectFormItem <name = %@, type = %@, key = %@, parentKey = %@, options = {%@}>", self.name, self.type, self.key, self.parentKey ? self.parentKey : @"-", self.options];
}

#pragma mark - FormItemDisplay
- (id)getValue {
    return [super getValue];
}

- (void)setValue:(id)aValue {
    if ([aValue isKindOfClass:[NSString class]]) {
        
    } else if ([aValue isKindOfClass:[FormItemOption class]]) {
        self.storedValue = aValue;
    }
}

- (BOOL)isValid {
    if (!self.shouldValidate) {
        return YES;
    }
    FormItemOption * value = [self getValue];
    if (self.optional)
        return YES;
    else
        if (value.title.length > 0)
            return YES;
    
    return NO;
}

@end
