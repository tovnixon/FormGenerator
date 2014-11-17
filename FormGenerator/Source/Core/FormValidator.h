//
//  FormValidator.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FormProtocol;
typedef void (^ValidationResultBlock)(NSString * errorMessage, BOOL success);
@interface FormValidator : NSObject

- (id)initWithItems:(NSArray *)formItems;
- (void)validateValue:(NSString *)value forKey:(NSString *)key result:(ValidationResultBlock)resultBlock;
@end
