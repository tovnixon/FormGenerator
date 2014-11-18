//
//  TextAreaFormItemCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "TextAreaFormItemCell.h"
#import "FormItemProtocol.h"
@implementation TextAreaFormItemCell
#pragma mark - FormItemCell delegate
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem showInfo:(BOOL)shouldShow delegate:(id<FormItemCellDelegate>)aDelegate {
    [super configureWithFormItem:aFormItem showInfo:NO delegate:aDelegate];
    self.tvInput.editable = aFormItem.readonly;
}

- (NSDictionary *)keyedValue {
    return @{kValidationKeyKey : [self bindingKey], kValidationValueKey : self.tvInput.text};
}

#pragma mark - TextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
}
@end
