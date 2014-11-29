//
//  SelectFormItemProtocol.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/23/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormItemProtocol.h"

@protocol SelectFormItemProtocol <FormItemProtocol>


@required
@property (nonatomic, copy, readonly) NSArray * options;
@end
