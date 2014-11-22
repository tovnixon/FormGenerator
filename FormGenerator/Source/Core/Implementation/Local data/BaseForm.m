//
//  BaseForm.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/11/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "BaseForm.h"
#import "BaseFormItem.h"
#import "MappingPair.h"
#import "BaseFormItem+Protected.h"
#import "DDXMLDocument.h"
//  keys should be same as in the target JSON
static NSString * formSerializationKeyRoot = @"form";

static NSString * formSerializationKeyFormID = @"formID";
static NSString * formSerializationKeyFields = @"fields";
static NSString * formSerializationKeyAsynch = @"isAsync";
static NSString * formSerializationKeyAgreeText = @"agreeText";
static NSString * formSerializationKeyTitle = @"title";
static NSString * formSerializationKeyDescription = @"description";
static NSString * formSerializationKeyFormStyle = @"formStyle";
static NSString * formSerializationKeyXMLDocType = @"xmlDocType";
static NSString * formSerializationKeySubmitButton = @"submitButton";
static NSString * formSerializationKeyCancelButton = @"cancelButton";

//  keys presenting actual class properties, can be used via KVC
static NSString * formPropertyKeyFormID = @"formID";
static NSString * formPropertyKeyFields = @"items";
static NSString * formPropertyKeyAsynch = @"async";
static NSString * formPropertyKeyAgreeText = @"agreeText";
static NSString * formPropertyKeyTitle = @"title";
static NSString * formPropertyKeyDescription = @"formDescription";
static NSString * formPropertyKeyFormStyle = @"formStyle";
static NSString * formPropertyKeyXMLDocType = @"xmlDocType";
static NSString * formPropertyKeySubmitButton = @"submitButton";
static NSString * formPropertyKeyCancelButton = @"cancelButton";
#pragma mark - Form

@interface BaseForm ()
@property (nonatomic, strong) NSArray * maping;
@property (nonatomic, copy) NSString * formID;
@property (nonatomic) FormStyle        formStyle;
@property (nonatomic, copy) NSArray  * items;

@end

@implementation BaseForm
@synthesize formID = _formID;
@synthesize formStyle = _formStyle;
@synthesize items = _items;
@synthesize async = _async;
@synthesize agreeText;
@synthesize title;
@synthesize formDescription;
@synthesize xmlDocType;
@synthesize submitButton;
@synthesize cancelButton;

- (instancetype)initWithForm:(id<FormProtocol>)aForm withItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self = aForm;
        self.items = items;
    }
    return self;
}

- (void)serializeWithDictionary:(NSDictionary *)dictionary {
    // look for root element, it's 'form' for now
    NSDictionary * dict = [dictionary valueForKey:formSerializationKeyRoot];
    for (MappingPair * mapPair in self.maping) {
        // map mathing
        if ([mapPair.keyFrom isEqualToString:formSerializationKeyFields]) {
            // specific case with array of itmes
            NSMutableArray * items = [NSMutableArray new];
            NSArray * itemDictionaries = [dict objectForKey:mapPair.keyFrom];
            for (NSDictionary * itemDictionary in itemDictionaries) {
                BaseFormItem * fi = [[BaseFormItem alloc] initWithDictionary:itemDictionary];
                [items addObject:fi];
            }
            self.items = [NSArray arrayWithArray:items];
        } else {
            // rest fields are plain
            [self setValue:[dict valueForKey:mapPair.keyFrom] forKey:mapPair.keyTo];
        }
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"BaseForm <formID = %@, description = %@ items = %@>", self.formID, self.formDescription, self.items];
}

#pragma mark - Form protocol
- (id)initWithJSONData:(NSData *)data {
    self = [super init];
    if (self) {

    self.maping = @[[MappingPair pairKey:formSerializationKeyFormID to:formPropertyKeyFormID],
                    [MappingPair pairKey:formSerializationKeyFields to:formPropertyKeyFields],
                    [MappingPair pairKey:formSerializationKeyAsynch to:formPropertyKeyAsynch],
                    [MappingPair pairKey:formSerializationKeyAgreeText to:formPropertyKeyAgreeText],
                    [MappingPair pairKey:formSerializationKeyTitle to:formPropertyKeyTitle],
                    [MappingPair pairKey:formSerializationKeyDescription to:formPropertyKeyDescription],
                    [MappingPair pairKey:formSerializationKeyFormStyle to:formPropertyKeyFormStyle],
                    [MappingPair pairKey:formSerializationKeyXMLDocType to:formPropertyKeyXMLDocType],
                    [MappingPair pairKey:formSerializationKeyCancelButton to:formPropertyKeyCancelButton],
                    [MappingPair pairKey:formSerializationKeySubmitButton to:formPropertyKeySubmitButton]];

        NSError * error = nil;
        NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (dictionary) {
            [self serializeWithDictionary:dictionary];
        } else {
            NSLog(@"Error: Failed to create valid form. %@", error.localizedDescription);
        }
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableArray * formParams = [NSMutableArray new];
    for (MappingPair * mapPair in self.maping) {
        if ([mapPair.keyFrom isEqualToString:formSerializationKeyFields]) {
            NSMutableArray * itemsParams = [NSMutableArray new];
            for (id<FormItemProtocol> formItem in self.items) {
                NSDictionary * itemDict = [formItem dictionaryPresentation];
                if (itemDict)
                    [itemsParams addObject:itemDict];
            }
            if (itemsParams.count)
                [formParams addObject:@{mapPair.keyFrom : itemsParams}];
        } else {
            NSDictionary * itemDict = @{mapPair.keyFrom : [self valueForKey:mapPair.keyTo]};
            if (itemDict)
                [formParams addObject:itemDict];
        }
    }
    NSDictionary * formDict = @{@"form" : formParams};
    return formDict;
}

- (NSString *)xmlString {
    NSError * error = nil;
    NSString * xml = @"<form></form>";
    
    DDXMLDocument * doc = [[DDXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    DDXMLElement * root = [doc rootElement];
    for (MappingPair * mapPair in self.maping) {
        if ([mapPair.keyFrom isEqualToString:formSerializationKeyFields]) {
            DDXMLElement * fields = [DDXMLElement elementWithName:mapPair.keyFrom];
            
            for (id<FormItemProtocol> formItem in self.items) {
                DDXMLNode * node = [formItem xmlElement];
                if (node) {
                    [fields addChild:node];
                }
            }
            if ([[fields children] count] > 0)
                [root addChild:fields];
                
        } else {
            NSString * val = [self valueForKey:mapPair.keyTo];
            if (val) {
                if ([val isKindOfClass:[NSNumber class]]) {
                    val = [(NSNumber *)val stringValue];
                }
                DDXMLNode * node = [DDXMLNode elementWithName:mapPair.keyFrom stringValue:val];
                [root addChild:node];
            }
        }
    }

    return [doc XMLString];
}
@end
