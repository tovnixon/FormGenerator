//
//  AbstractFormItemCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//
#import "AbstractFormItemCell.h"
#import "FormItemProtocol.h"
@implementation AbstractFormItemCell
@synthesize bindingKey;
@synthesize delegate;
@synthesize dataSourceKey;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

#pragma mark - FormItemCell delegate
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem showInfo:(BOOL)shouldShow delegate:(id<FormItemCellDelegate>)aDelegate {
    self.bindingKey = [aFormItem bindingKey];
    self.dataSourceKey = [aFormItem key];
    if (aFormItem.helpText.length > 0) {
        self.cnstrRightEnd2Right.constant = 50;
        self.btnHelpInfo.hidden = NO;
    } else {
        self.btnHelpInfo.hidden = YES;
    }
    self.lblTitle.text = aFormItem.label;
    self.lblDescription.text = aFormItem.itemDescription;
    self.delegate = aDelegate;
    
    shouldShow ? [self.errorView show] : [self.errorView silentHide];
    self.cnstrTitle2Left.constant = aFormItem.valid ? 20 : 50;
    [self.errorView updateWithMessage:aFormItem.errorMessage];
    self.validationSign.hidden = aFormItem.valid;
}

- (NSDictionary *)keyedValue {
    return nil;
}

- (CGSize)calculateSize:(CGSize)parentSize {
    return CGSizeZero;
}
#pragma mark - validation
- (IBAction)onSignTap:(id)sender {
    [self showErrorMessage];
}

- (void)updateValidationInfo:(NSString *)message valid:(BOOL)isValid {
    self.valid = isValid;
    isValid ? [self hideErrorMessage] : [self showErrorMessage];
    self.cnstrTitle2Left.constant = self.valid ? 20 : 50;
    self.validationSign.hidden = self.valid;

    [self.delegate cellValueChanged:self validationRequired:NO];
}

- (void)hideErrorMessage {
    [self.errorView hide];
}

- (void)showErrorMessage {
    [self.errorView show];
}

#pragma mark - Message view delegate 

- (void)didShow {
    [self.delegate heightChangedInCell:self grow:YES];
}

- (void)didHide {
    [self.delegate heightChangedInCell:self grow:NO];
}

#pragma mark - Actions
- (IBAction)helpInfo:(id)sender {

}

- (void)forceLayout {
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
