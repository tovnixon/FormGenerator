//
//  BaseFormItem.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/11/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "BaseFormItem.h"

#import "BaseFormItem+Protected.h"


@interface BaseFormItem ()

@end

@implementation BaseFormItem
@synthesize pageId;
@synthesize type;
@synthesize name;
@synthesize label;
@synthesize readonly;
@synthesize defaultValue;
@synthesize itemDescription;
@synthesize validationPattern;
@synthesize helpText;
@synthesize maxLength;
@synthesize optional;
@synthesize parentKey;
@synthesize key;

@synthesize valid;
@synthesize errorMessage;
@synthesize storedValue;
@synthesize displayErrorMessage;
@synthesize storedValues;
@synthesize shouldValidate;
@synthesize children;
@synthesize level;

- (id)init {
    self = [super init];
    if (self) {
        // value is useful param when you have array of form items as a data source of table view
        self.storedValues = [NSMutableArray new];
        self.valid = YES;
        self.shouldValidate = NO;
        self.errorMessage = @"Неверный формат";
        self.displayErrorMessage = NO;
        self.maping = [@[[MappingPair pairKey:formItemSerializationKeyType to:formItemPropertyKeyType],
                         [MappingPair pairKey:formItemSerializationKeyName to:formItemPropertyKeyName],
                         [MappingPair pairKey:formItemSerializationKeyLabel to:formItemPropertyKeyLabel],
                         [MappingPair pairKey:formItemSerializationKeyReadonly to:formItemPropertyKeyReadonly],
                         [MappingPair pairKey:formItemSerializationKeyDefaultValue to:formItemPropertyKeyDefaultValue],
                         [MappingPair pairKey:formItemSerializationKeyValidation to:formItemPropertyKeyValidation],
                         [MappingPair pairKey:formItemSerializationKeyHelpText to:formItemPropertyKeyHelpText],
                         [MappingPair pairKey:formItemSerializationKeyMaxLength to:formItemPropertyKeyMaxLength],
                         [MappingPair pairKey:formItemSerializationKeyDescription to:formItemPropertyKeyDescription]] mutableCopy];

        // признак того что если данный параметр присутствует и он "true", поле не обязательно к заполнению ,т.е. может остаться пустым. Если не указано - по умолчанию false
    }
    return self;
}

- (instancetype)initWithType:(NSString *)aType name:(NSString *)aName value:(NSString *)aValue description:(NSString *)aDescription pageId:(NSString *)aPageId {
    return [self initWithType:aType name:aName value:aValue description:aDescription pageId:aPageId level:nil];
}

- (instancetype)initWithType:(NSString *)aType name:(NSString *)aName value:(NSString *)aValue description:(NSString *)aDescription pageId:(NSString *)aPageId level:(NSNumber *)aLevel {

    self = [self init];
    if (self) {
        [self setValue:aName forKey:@"name"];
        [self setValue:aValue forKey:@"label"];
        [self setValue:aDescription forKey:@"itemDescription"];
        [self setValue:aType forKey:@"type"];
        if (!aLevel) aLevel = [NSNumber numberWithInteger:0];
        [self setValue:aLevel forKey:@"level"];
        if (aPageId)
            [self setValue:aPageId forKey:@"pageId"];
        [self createBindingKey];
    }
    return self;
}

- (void)createBindingKey {
    self.key = [NSString stringWithFormat:@"%@_%d", self.name, arc4random()%10000];
}

#pragma mark - FormItemProtocol
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        if (dictionary) {
            [self serializeFromDictionary:dictionary];
        }
        [self createBindingKey];
    }
    return self;
}

- (NSDictionary *)dictionaryPresentation {
    NSString * value = self.storedValue ? self.storedValue : self.defaultValue;
    if (value)
        return @{self.name : value};
    else
        return nil;
}

- (DDXMLNode *)xmlElement {
    NSString * value = self.storedValue ? self.storedValue : self.defaultValue;
    if (value) {
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [(NSNumber *)value stringValue];
        }
        return [DDXMLNode elementWithName:self.name stringValue:value];
    }
    else
        return nil;
}

- (void)serializeFromDictionary:(NSDictionary *)dictionary {
    for (MappingPair * mp in self.maping) {
        id val = [dictionary objectForKey:mp.keyFrom];
        if (val) {
            [self setValue:val forKey:mp.keyTo];
        }
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"BaseFormItem <name = %@, type = %@, key = %@, parentKey = %@>", self.name, self.type, self.key, self.parentKey ? self.parentKey : @"-"];
}

#pragma mark - FormItemDisplay
- (NSString *)bindingKey {
    return self.key;
}

- (id)getValue {
    if (self.storedValue) {
        return self.storedValue;
    } else if (self.defaultValue) {
        return self.defaultValue;
    }
    return nil;
}

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

- (void)setValue:(id)aValue {
    if ([aValue isKindOfClass:[NSString class]])
        self.storedValue = aValue;
}

- (BOOL)hasParent {
    return self.parentKey != nil && self.parentKey.length > 0;
}
@end
