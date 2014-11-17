//
//  BaseFormItem.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/11/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "BaseFormItem.h"
#import "MappingPair.h"
#import "BaseFormItem+Protected.h"
#import "DDXMLDocument.h"

@interface BaseFormItem ()
@property (nonatomic, strong) NSArray * maping;
@end

@implementation BaseFormItem
@synthesize type;
@synthesize name;
@synthesize label;
@synthesize readonly;
@synthesize defaultValue;
@synthesize itemDescription;
@synthesize storedValue;
@synthesize storedValues;
@synthesize validationPattern;
@synthesize helpText;
@synthesize maxLength;
@synthesize subItems;
@synthesize optional;

@synthesize selectionOptions;
@synthesize parentKey;
@synthesize key;
@synthesize children;

- (id)init {
    self = [super init];
    if (self) {
        // value is useful param when you have array of form items as a data source of table view
        self.storedValue = nil;
        self.storedValues = [NSMutableArray new];
        // признак того что если данный параметр присутствует и он "true", поле не обязательно к заполнению ,т.е. может остаться пустым. Если не указано - по умолчанию false
    }
    return self;
}

- (instancetype)initWithType:(FormItemType)aType name:(NSString *)aName value:(NSString *)aValue description:(NSString *)aDescription {
    self = [self init];
    if (self) {
        [self setValue:aName forKey:@"name"];
        [self setValue:aValue forKey:@"label"];
        [self setValue:aDescription forKey:@"itemDescription"];
        [self setValue:@(aType) forKey:@"type"];
        self.key = [NSString stringWithFormat:@"%@_%d", self.name, arc4random()%10000];
    }
    return self;
}

#pragma mark - FormItemProtocol
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        self.maping = @[[MappingPair pairKey:formItemSerializationKeyType to:formItemPropertyKeyType],
                        [MappingPair pairKey:formItemSerializationKeyName to:formItemPropertyKeyName],
                        [MappingPair pairKey:formItemSerializationKeyLabel to:formItemPropertyKeyLabel],
                        [MappingPair pairKey:formItemSerializationKeyReadonly to:formItemPropertyKeyReadonly],
                        [MappingPair pairKey:formItemSerializationKeyDefaultValue to:formItemPropertyKeyDefaultValue],
                        [MappingPair pairKey:formItemSerializationKeyValidation to:formItemPropertyKeyValidation],
                        [MappingPair pairKey:formItemSerializationKeyHelpText to:formItemPropertyKeyHelpText],
                        [MappingPair pairKey:formItemSerializationKeyMaxLength to:formItemPropertyKeyMaxLength],
                        [MappingPair pairKey:formItemSerializationKeySelectionOptions to:formItemPropertyKeySelectionOptions],
                        [MappingPair pairKey:formItemSerializationKeySubItems to:formItemPropertyKeySubItems],
                        [MappingPair pairKey:formItemSerializationKeyDescription to:formItemPropertyKeyDescription]];
        if (dictionary) {
            [self serializeFromDictionary:dictionary];
        }
        self.children = [NSMutableArray new];
        self.key = [NSString stringWithFormat:@"%@_%d", self.name, arc4random()%10000];
    }
    return self;
}

- (NSString *)bindingKey {
    return self.key;
}

- (NSDictionary *)dictionaryPresentation {
    if (self.type == FormItemTypeNestedGroup) {
        NSMutableArray * subItemDictionaries = [NSMutableArray new];
        for (id <FormItemProtocol> subItem in self.subItems) {
            [subItemDictionaries addObject:[subItem dictionaryPresentation]];
        }
        return @{self.name : [NSArray arrayWithArray:subItemDictionaries]};
    }
    NSString * value = self.storedValue ? self.storedValue : self.defaultValue;
    if (value)
        return @{self.name : value};
    else
        return nil;

}

- (DDXMLNode *)xmlElement {
    if (self.type == FormItemTypeNestedGroup) {
        DDXMLElement * element = [DDXMLElement elementWithName:self.name];
        for (id <FormItemProtocol> subItem in self.subItems) {
            DDXMLElement * element = [subItem xmlElement];
            [element addChild:element];
        }
        return element;
    }
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
            if ([mp.keyFrom isEqualToString:formItemSerializationKeySubItems]) {
                NSArray * array = val;
                NSMutableArray * formSubItems = [NSMutableArray new];
                for (NSDictionary * dict in array) {
                    BaseFormItem * fi = [[BaseFormItem alloc] initWithDictionary:dict];
                    [formSubItems addObject:fi];
                }
                self.subItems = [NSArray arrayWithArray:formSubItems];
//                [self setValue:[NSArray arrayWithArray:formSubItems] forKey:mp.keyTo];
            } else {
                [self setValue:val forKey:mp.keyTo];
            }
        }
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"BaseFormItem <name = %@, type = %i>", self.name, self.type];
}

@end
