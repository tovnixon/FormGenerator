//
//  LabelFormItemCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "LabelFormItemCell.h"
#import "FormItemProtocol.h"
#import "FormItemDisplay.h"

@implementation LabelFormItemCell
@synthesize leftView;
@synthesize rightView;
#pragma mark - FormItemCell delegate
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem delegate:(id<FormItemCellDelegate>)aDelegate {
    [super configureWithFormItem:aFormItem delegate:aDelegate];
    self.lblValue.text = [aFormItem getValue];
}

- (NSDictionary *)keyedValue {
    return @{kValidationKeyKey :[self bindingKey], kValidationValueKey : self.lblValue.text};
}
@end
