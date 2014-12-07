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
@synthesize showInfoView;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

#pragma mark - FormItemCell delegate
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem delegate:(id<FormItemCellDelegate>)aDelegate {
    self.bindingKey = [aFormItem bindingKey];
    self.dataSourceKey = [aFormItem key];
    if (aFormItem.helpText.length > 0) {
        self.cnstrRightEnd2Right.constant = cnstrRightOffset;
        self.btnHelpInfo.hidden = NO;
    } else {
        self.btnHelpInfo.hidden = YES;
    }
    self.lblTitle.text = aFormItem.label;
    self.lblDescription.text = aFormItem.itemDescription;
    self.delegate = aDelegate;
//
    BOOL isValid = [aFormItem isValid];
    self.showInfoView = aFormItem.displayErrorMessage;

    self.cnstrTitle2Left.constant = isValid ? cnstrTitle2LeftDefault : cnstrTitle2LeftOffset;
//    self.showInfoView ? [self.infoView show] : [self.infoView silentHide];
    self.showInfoView ? [self.infoView silentShow] : [self.infoView silentHide];
    [self.infoView updateWithMessage:aFormItem.errorMessage];
    self.validationSign.hidden = isValid;
    
    self.lblTitle.preferredMaxLayoutWidth = isValid ? 274 : 224;
}

- (NSDictionary *)keyedValue {
    return nil;
}

- (CGSize)calculateSize:(CGSize)parentSize {
    return CGSizeZero;
}
#pragma mark - validation
- (IBAction)onSignTap:(id)sender {
    self.showInfoView = !self.showInfoView;
    [self.delegate cellValueChanged:self];
}

- (void)hideErrorMessage {
    [self.infoView hide];
}

- (void)showErrorMessage {
    [self.infoView show];
}

#pragma mark - Message view delegate 

- (void)didShow {
    self.showInfoView = YES;
    [self.delegate cellValueChanged:self];
}

- (void)didHide {
    self.showInfoView = NO;
    [self.delegate cellValueChanged:self];
}

#pragma mark - Actions
- (IBAction)helpInfo:(id)sender {

}

@end
