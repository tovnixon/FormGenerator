//
//  AbstractFormItemCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//
#import "AbstractFormItemCell.h"
#import "FormItemProtocol.h"
#import "UILabel+DynamicHeigth.h"
@implementation AbstractFormItemCell
@synthesize bindingKey;
@synthesize delegate;
@synthesize dataSourceKey;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIImage * imgSign =[UIImage imageNamed:@"icoError7.png"];
        self.validationSign = [UIButton buttonWithType:UIButtonTypeCustom];
        _validationSign.frame = CGRectMake(0, 0, imgSign.size.width, imgSign.size.height);
        [_validationSign setImage:imgSign forState:UIControlStateNormal];
        [_validationSign setImage:imgSign forState:UIControlStateSelected];
        [_validationSign setImage:imgSign forState:UIControlStateHighlighted];
        [_validationSign addTarget:self action:@selector(onValidationSign) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - FormItemCell delegate
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem showInfo:(BOOL)shouldShow {
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
    shouldShow ? [self.errorView show] : [self.errorView silentHide];
    [self forceLayout];
}

- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem {
    [self configureWithFormItem:aFormItem showInfo:NO];
}

- (NSDictionary *)keyedValue {
    return nil;
}

#pragma mark - validation
- (void)onValidationSign {
    [self showErrorMessage:self.currentErrorMessage];
}

- (void)updateValidationInfo:(NSString *)message valid:(BOOL)isValid {
    
    if (isValid) {
        self.cnstrTitle2Left.constant = 20;
        [self forceLayout];
        [self.validationSign removeFromSuperview];
        self.currentErrorMessage = nil;
        [self hideErrorMessage];
    } else {
        self.cnstrTitle2Left.constant = 50;
        [self forceLayout];
        [self addSubview:self.validationSign];
        self.validationSign.center = CGPointMake(10 + self.validationSign.bounds.size.width, self.bounds.size.height * .5);
        self.currentErrorMessage = message;
    }
    [self forceLayout];
}

- (void)hideErrorMessage {
    [self.errorView hide];
    [self forceLayout];
}

- (void)showErrorMessage:(NSString *)message {
    [self.errorView updateWithMessage:message];
    [self forceLayout];
    [self.errorView show];
    [self forceLayout];
    [self.delegate heightChangedInCell:self grow:YES];
}

#pragma mark - Message view delegate 

- (void)didHide {
    [self forceLayout];
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
