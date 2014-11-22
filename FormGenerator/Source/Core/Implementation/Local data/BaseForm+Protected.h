//
//  BaseForm+Protected.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/16/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//
#import "BaseForm.h"
#ifndef FormGenerator_BaseForm_Protected_h
#define FormGenerator_BaseForm_Protected_h

@interface BaseForm()
- (instancetype)initWithForm:(id<FormProtocol>)aForm withItems:(NSArray *)items;
@end

#endif
