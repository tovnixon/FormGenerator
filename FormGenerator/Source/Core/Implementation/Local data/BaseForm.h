//
//  BaseForm.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/11/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormProtocol.h"
@protocol FormItemProtocol;

@interface BaseForm : NSObject <FormProtocol>
- (NSDictionary *)dictionaryRepresentation;
@end
