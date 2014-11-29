//
//  SingleSelectionFormItemCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/13/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "SingleSelectionFormItemCell.h"
#import "FormItemProtocol.h"
#import "FormItemOption.h"

@implementation SingleSelectionFormItemCell

#pragma mark - FormItemCell delegate
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem delegate:(id<FormItemCellDelegate>)aDelegate {
    [super configureWithFormItem:aFormItem delegate:aDelegate];
    self.lblValue.text = [(FormItemOption *)[aFormItem getValue] title];
}

- (NSDictionary *)keyedValue {
    return @{kValidationKeyKey :[self bindingKey],
             kValidationValueKey : self.lblValue.text ? self.lblValue.text : @"",
             kShowInfoKey : [NSNumber numberWithBool:self.showInfoView]};
}

@end
