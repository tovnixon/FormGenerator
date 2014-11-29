//
//  GroupFormItemProtocol.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/24/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormItemProtocol.h"
@protocol GroupFormItemProtocol <FormItemProtocol>

@required
@property (nonatomic, copy) NSArray * subItems;

@end
