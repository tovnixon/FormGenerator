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
    self.tvInput.text = [aFormItem storedValue] ? [aFormItem storedValue] : [aFormItem defaultValue];
    self.cntrTextViewHeight.constant = [self.tvInput sizeThatFits:CGSizeMake(440, FLT_MAX)].height;

}

- (NSDictionary *)keyedValue {
    return @{kValidationKeyKey : [self bindingKey],
             kValidationValueKey : self.tvInput.text,
             kIsValidKey : [NSNumber numberWithBool:self.valid]};
}

- (CGSize)calculateSize:(CGSize)parentSize {
    CGSize size = [self.tvInput sizeThatFits:CGSizeMake(440, FLT_MAX)];
    CGSize descriptionSize = [self.lblDescription sizeThatFits:CGSizeMake(528, FLT_MAX)];
    NSLog(@"Textview = %@", NSStringFromCGSize(size));
    return CGSizeMake(1, size.height + descriptionSize.height + 20);
}
#pragma mark - TextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [textView becomeFirstResponder];
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
