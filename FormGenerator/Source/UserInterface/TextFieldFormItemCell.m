//
//  TextFieldFormItemCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "TextFieldFormItemCell.h"
#import "FormItemProtocol.h"


@interface TextFieldFormItemCell()

@end

@implementation TextFieldFormItemCell

//become first responder by tap on cell
- (BOOL)becomeFirstResponder {
    [self.txtInput becomeFirstResponder];
    return [super becomeFirstResponder];
}

#pragma mark - FormItemCell delegate

- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem showInfo:(BOOL)shouldShow delegate:(id<FormItemCellDelegate>)aDelegate {
    [super configureWithFormItem:aFormItem showInfo:shouldShow delegate:aDelegate];
    self.txtInput.text = [aFormItem storedValue] ? [aFormItem storedValue] : [aFormItem defaultValue];
}

- (NSDictionary *)keyedValue {
    return @{kValidationKeyKey : [self bindingKey],
             kValidationValueKey : self.txtInput.text,
             kIsValidKey : [NSNumber numberWithBool:self.valid]};
}

#pragma mark - Textfield delegate
//TODO:
//implement max length here
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate cellValueChanged:self validationRequired:YES];
}
@end
