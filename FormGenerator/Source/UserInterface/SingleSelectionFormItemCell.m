//
//  SingleSelectionFormItemCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/13/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "SingleSelectionFormItemCell.h"
#import "FormItemProtocol.h"
@implementation SingleSelectionFormItemCell

#pragma mark - FormItemCell delegate
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem showInfo:(BOOL)shouldShow delegate:(id<FormItemCellDelegate>)aDelegate {
    [super configureWithFormItem:aFormItem showInfo:NO delegate:aDelegate];
    self.lblValue.text = [aFormItem storedValue];
}

- (NSDictionary *)keyedValue {
    return @{kValidationKeyKey :[self bindingKey], kValidationValueKey : self.lblValue.text ? self.lblValue.text : @""};
}

- (void)updateValidationInfo:(NSString *)message valid:(BOOL)isValid {
    [super updateValidationInfo:message valid:isValid];
}

@end
