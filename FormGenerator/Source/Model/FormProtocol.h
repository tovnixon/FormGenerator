//
//  FormProtocol.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/11/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FormStyleDefault = 0
}FormStyle;

typedef enum {
    SubmitButtonStyledefault = 0
}SubmitButtonStyle;

typedef enum {
    CancelButtonStyleDefault = 0
}CancelButtonStyle;

@protocol FormProtocol <NSObject>

@required

@property (nonatomic, copy, readonly) NSString * formID;
@property (nonatomic, readonly) FormStyle        formStyle;
@property (nonatomic, copy, readonly) NSArray * items;

- (id)initWithJSONData:(NSData *)data;
- (NSString *)xmlString;
@optional

@property (nonatomic)                 BOOL       async;
@property (nonatomic, copy, readonly) NSString * xmlDocType;
@property (nonatomic, copy, readonly) NSString * submitButton;
@property (nonatomic, copy, readonly) NSString * cancelButton;
@property (nonatomic, readonly) SubmitButtonStyle submitButtonStyleStyle;
@property (nonatomic, readonly) CancelButtonStyle cancelButtonStyle;
@property (nonatomic, copy, readonly) NSString * title;
@property (nonatomic, copy, readonly) NSString * formDescription;
@property (nonatomic, copy, readonly) NSString * agreeText;

#warning param pages is mentioned in documentation but i don't know how to use it and do we really need it

@end
