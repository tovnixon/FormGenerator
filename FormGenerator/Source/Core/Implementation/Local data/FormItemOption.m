//
//  FormItemOption.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/13/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "FormItemOption.h"

@interface FormItemOption()
@property (nonatomic, copy) NSString * value;
@end

@implementation FormItemOption


+ (id)optionWithString:(NSString *)string {
    FormItemOption * fio = [FormItemOption new];
    fio.value = string;
    return fio;
}
@end
