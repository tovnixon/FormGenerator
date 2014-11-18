//
//  BoolFormItemCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "BoolFormItemCell.h"
#import "FormItemProtocol.h"

@interface BoolFormItemCell()
- (IBAction)valueChanged:(id)sender;
 @end

@implementation BoolFormItemCell

- (IBAction)valueChanged:(id)sender {
    [self.delegate cellValueChanged:self validationRequired:YES];
}

#pragma mark - FormItemCell delegate
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem showInfo:(BOOL)shouldShow delegate:(id<FormItemCellDelegate>)aDelegate {
    [super configureWithFormItem:aFormItem showInfo:NO delegate:aDelegate];
    self.switcher.enabled = !aFormItem.readonly;
    if (aFormItem.storedValue) {
        [self.switcher setOn:[aFormItem.storedValue isEqualToString:@"true"] animated:YES];
    } else {
        [self.switcher setOn:[aFormItem.defaultValue isEqualToString:@"true"] animated:YES];
    }
}

- (NSDictionary *)keyedValue {
    NSString * value = [self.switcher isOn] ? @"true" : @"false";
    return @{kValidationKeyKey : [self bindingKey], kValidationValueKey : value};
}

@end
