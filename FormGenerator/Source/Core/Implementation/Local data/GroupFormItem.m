//
//  GroupFormItem.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/24/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "GroupFormItem.h"
#import "BaseFormItem+Protected.h"
@implementation GroupFormItem
@synthesize subItems;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self.maping addObject:[MappingPair pairKey:formItemSerializationKeySubItems to:formItemPropertyKeySubItems]];
        if (dictionary)
            [self serializeFromDictionary:dictionary];
        [self createBindingKey];
    }
    return self;
}


- (void)serializeFromDictionary:(NSDictionary *)dictionary {

    for (MappingPair * mp in self.maping) {
        id val = [dictionary objectForKey:mp.keyFrom];
        if (val) {
            if ([mp.keyFrom isEqualToString:formItemSerializationKeySubItems]) {
                NSArray * array = val;
                NSMutableArray * formSubItems = [NSMutableArray new];
                NSMutableArray * myChildren = [@[] mutableCopy];
                for (NSDictionary * dict in array) {
                    Class fiClass = [[FormItemTypes2Classes sharedInstance] formItemClassByType:[dict valueForKey:formItemSerializationKeyType]];
                    id fi = [[fiClass alloc] initWithDictionary:dict];
                    [myChildren addObject:[fi key]];
                    [formSubItems addObject:fi];
                }
                self.subItems = [NSArray arrayWithArray:formSubItems];
                self.children = myChildren;
            } else {
                [self setValue:val forKey:mp.keyTo];
            }
        }
    }
}

- (DDXMLNode *)xmlElement {
    DDXMLElement * container = [[DDXMLElement alloc] initWithName:self.name];
    for (id <FormItemProtocol> subItem in self.subItems) {
        DDXMLNode * element = [subItem xmlElement];
        [container addChild:element];
    }
    return container;
}

- (NSDictionary *)dictionaryPresentation {
    NSMutableArray * subItemDictionaries = [NSMutableArray new];
    for (id <FormItemProtocol> subItem in self.subItems) {
        [subItemDictionaries addObject:[subItem dictionaryPresentation]];
    }
    return @{self.name : [NSArray arrayWithArray:subItemDictionaries]};
}

- (NSString *)description {
    return [NSString stringWithFormat:@"GroupFormItem <name = %@, type = %@, key = %@, parentKey = %@, subItems = {%@}, >", self.name, self.type, self.key, self.parentKey ? self.parentKey : @"-", self.subItems ? self.subItems : @"-"];
}


@end
