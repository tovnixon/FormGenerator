//
//  TextFieldFormItemCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "TextFieldFormItemCell.h"
#import "FormItemProtocol.h"
#import "UILabel+DynamicHeigth.h"

@interface TextFieldFormItemCell()

@end

@implementation TextFieldFormItemCell

//become first responder by tap on cell
- (BOOL)becomeFirstResponder {
    [self.txtInput becomeFirstResponder];
    return [super becomeFirstResponder];
}

#pragma mark - FormItemCell delegate
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem {
    [super configureWithFormItem:aFormItem];
    self.txtInput.text = [aFormItem storedValue] ? [aFormItem storedValue] : [aFormItem defaultValue];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (NSDictionary *)keyedValue {
    return @{kValidationKeyKey : [self bindingKey], kValidationValueKey : self.txtInput.text};
}

- (void)updateValidationInfo:(NSString *)message valid:(BOOL)isValid {
    [super updateValidationInfo:message valid:isValid];
}

#pragma mark - Textfield delegate
//TODO:
//implement max length here
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate cellValueChanged:self];
}
@end
