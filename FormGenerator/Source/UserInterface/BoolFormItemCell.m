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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.delegate cellValueChanged:self];
    });
    
}

#pragma mark - FormItemCell delegate
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem delegate:(id<FormItemCellDelegate>)aDelegate {
    [super configureWithFormItem:aFormItem delegate:aDelegate];
    if (aFormItem.readonly) {
        self.switcher.enabled = NO;
    }

    [self.switcher setOn:[[aFormItem getValue] boolValue] animated:YES];
}

- (NSDictionary *)keyedValue {
    return @{kValidationKeyKey : [self bindingKey],
             kValidationValueKey : [NSNumber numberWithBool:self.switcher.on],
             kShowInfoKey : [NSNumber numberWithBool:self.showInfoView]};
}

@end
