//
//  FormItemProtocol.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/11/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormItemDisplay.h"
@class DDXMLNode;

static NSString * FormItemTypeLabel = @"string";
static NSString * FormItemTypeText = @"text";
static NSString * FormItemTypeTextArea = @"textArea";
static NSString * FormItemTypeSingleSelection = @"radio";
static NSString * FormItemTypeSingleSelectionSmart = @"select2";
static NSString * FormItemTypeMultipleSelection = @"???";
static NSString * FormItemTypeConverter = @"ccyConverter";
static NSString * FormItemTypeLookUp = @"lookup";
static NSString * FormItemTypeCheckBox = @"checkbox";
static NSString * FormItemTypeCarousel = @"carousel";
static NSString * FormItemTypeNestedGroup = @"group";
static NSString * FormItemTypeArray = @"array";
static NSString * FormItemTypeDescription = @"description";
static NSString * FormItemTypeAgree = @"agreeText";

@protocol FormItemProtocol <NSObject, FormItemDisplay>

//model - comes from initialization
@required
@property (nonatomic, strong) NSString * parentKey;
@property (nonatomic, strong) NSString * key;
@property (nonatomic, copy) NSString * pageId;

@property (nonatomic, copy, readonly) NSString * type;
@property (nonatomic, copy, readonly) NSString * name;
@property (nonatomic, copy, readonly) NSString * label;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryPresentation;
- (DDXMLNode *)xmlElement;
@optional

@property (nonatomic, copy, readonly) NSString * itemDescription;
@property (nonatomic, copy, readonly) NSString * helpText;
@property (nonatomic, copy, readonly) NSString * defaultValue;
@property (nonatomic, copy, readonly) NSString * validationPattern;
@property (nonatomic, readonly) BOOL readonly;
@property (nonatomic, readonly) BOOL hidden;
@property (nonatomic, readonly) BOOL optional;
@property (nonatomic, copy, readonly) NSNumber * maxLength;

- (BOOL)hasParent;
@end

