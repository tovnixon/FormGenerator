//
//  FormItemProtocol.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/11/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DDXMLNode;
@protocol FormItemBinding
@required
//stored value - to be populated by user
@property (nonatomic, strong) NSString * storedValue;
@property (nonatomic, strong) NSArray * storedValues;

@property (nonatomic, strong) NSString * parentKey;
@property (nonatomic, strong) NSString * key;
@property (nonatomic, strong) NSMutableArray * children;
@property (nonatomic) BOOL valid;
@property (nonatomic, strong) NSString * errorMessage;
- (NSString *)bindingKey;

@end

typedef enum {
    FormItemTypeLabel = 0,
    FormItemTypeText,
    FormItemTypeTextArea,
    FormItemTypeSingleSelection,
    FormItemTypeMultipleSelection,
    FormItemTypeLookUp,
    FormItemTypeCheckBox,
    FormItemTypeCarousel,
    FormItemTypeNestedGroup,
    FormItemTypeContainer,
    FormItemTypeDescription,
    FormItemTypeAgree
}FormItemType;

typedef enum {
    FormItemInputStyleDefault = 0
}FormItemInputStyle;

@protocol FormItemProtocol <NSObject, FormItemBinding>

//model - comes from initialization
@required
@property (nonatomic, readonly) FormItemType       type;
@property (nonatomic, copy, readonly) NSString * name;
@property (nonatomic, copy, readonly) NSString * label;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryPresentation;
- (DDXMLNode *)xmlElement;
@optional

@property (nonatomic, readonly) FormItemInputStyle inputStyle;
@property (nonatomic, copy, readonly) NSString * itemDescription;
@property (nonatomic, copy, readonly) NSString * helpText;
@property (nonatomic, copy, readonly) NSString * defaultValue;
@property (nonatomic, copy, readonly) NSString * validationPattern;
@property (nonatomic, readonly) BOOL readonly;
@property (nonatomic, readonly) BOOL hidden;
@property (nonatomic, readonly) BOOL optional;
@property (nonatomic, copy, readonly) NSNumber * maxLength;
@property (nonatomic, copy) NSArray * subItems;
@property (nonatomic, copy, readonly) NSArray * selectionOptions;
@end

