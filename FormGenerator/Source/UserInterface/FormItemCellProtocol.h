//
//  FormItemCellProtocol.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>

// keys to create a dictionary like
// @{kValidationKeyKey   : [self bindingKey],
//   kValidationValueKey : [self valueDependsOnClass]}

static NSString * kValidationKeyKey = @"kValidationKeyKey";
static NSString * kValidationValueKey = @"kValidationValueKey";
static NSString * kShowInfoKey = @"kShowInfoKey";

@protocol FormItemProtocol;
@protocol FormItemCellProtocol;
@protocol FormItemCellDelegate
- (void)accessoryTappedInCell:(id<FormItemCellProtocol>)cell;
- (void)cellValueChanged:(id<FormItemCellProtocol>)cell;
@end

@protocol FormItemCellProtocol <NSObject>
#warning form item should be copy, not strong. So you nned to implement NSCopying for FormItem
@property (nonatomic, strong) NSString * bindingKey;
@property (nonatomic, weak) id <FormItemCellDelegate> delegate;
@property (nonatomic, strong) NSString * dataSourceKey;
@required
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem delegate:(id<FormItemCellDelegate>)aDelegate;
//should be overrided in each subclass, returns dictionary with one key-value pair
// key = formItem.name, value = user input
- (NSDictionary *)keyedValue;

@optional

- (CGSize)calculateSize:(CGSize)parentSize;
@end




