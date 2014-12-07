//
//  FormDescriptionCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/16/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "FormDescriptionCell.h"
#import "FormItemProtocol.h"
@interface FormDescriptionCell() {
    BOOL _singleLoad;
}

@end
@implementation FormDescriptionCell
#pragma mark - FormItemCell delegate
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem delegate:(id<FormItemCellDelegate>)aDelegate {
    self.dataSourceKey = [aFormItem key];
}

- (CGSize)calculateSize:(CGSize)parentSize {
    return CGSizeMake(1, 120);
}


@end
