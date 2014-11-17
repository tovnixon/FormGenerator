//
//  FormConfigurator.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/14/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormItemProtocol.h"
#import "FormProtocol.h"

@interface FormConfigurator : NSObject

- (id)initWithForm:(id<FormProtocol>)aForm;
- (NSString *)xmlStringWithItems:(NSArray *)linearItems;
- (NSArray *)linearedItems;
- (NSString *)cancelTitle;
- (NSString *)submitTitle;
- (NSString *)formTitle;
@end
