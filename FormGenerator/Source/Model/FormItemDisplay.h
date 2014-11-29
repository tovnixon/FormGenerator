//
//  FormItemDisplay.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/25/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FormItemDisplay <NSObject>
@required
//stored value - to be populated by user

@property (nonatomic, strong) NSArray * storedValues;
@property (nonatomic, strong) id storedValue;
@property (nonatomic) BOOL shouldValidate;
@property (nonatomic) BOOL valid;
@property (nonatomic) BOOL displayErrorMessage;
@property (nonatomic, strong) NSString * errorMessage;
@property (nonatomic, strong) NSArray * children;
- (NSString *)bindingKey;
@optional
- (id)getValue;
- (void)setValue:(id)aValue;
- (BOOL)isValid;

@end
