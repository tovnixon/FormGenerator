//
//  AgreeFormItemCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/16/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "AgreeFormItemCell.h"
#import "FormItemProtocol.h"

@interface AgreeFormItemCell() {
    BOOL _singleLoad;
}
@end

@implementation AgreeFormItemCell
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem delegate:(id<FormItemCellDelegate>)aDelegate {
    
    self.bindingKey = [aFormItem bindingKey];
    self.dataSourceKey = [aFormItem key];
}

- (IBAction)switched:(id)sender {
    [self.delegate cellValueChanged:self];
}

- (NSDictionary *)keyedValue {
    NSString * value = [self.switcher isOn] ? @"true" : @"false";
    return @{kValidationKeyKey : [self bindingKey], kValidationValueKey : value};
}

- (CGSize)calculateSize:(CGSize)parentSize {
    return CGSizeMake(1, 120);
}


@end
