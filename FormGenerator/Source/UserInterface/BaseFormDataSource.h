//
//  BaseFormDataSource.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UITableView.h>
#import "FormItemCellProtocol.h"
@protocol FormProtocol;
@protocol FormItemProtocol;
@protocol FormItemCellProtocol;

@interface BaseFormDataSource : NSObject <UITableViewDataSource, FormItemCellDelegate>

@property (nonatomic, copy, readonly) NSString * formTitle;
@property (nonatomic, copy, readonly) NSString * cancelTitle;
@property (nonatomic, copy, readonly) NSString * submitTitle;
@property (nonatomic) BOOL shouldValidateAll;
- (id)initWithForm:(id<FormProtocol>)aForm;
- (BOOL)validateValuesIn:(UITableView *)tableView;
- (BOOL)shouldSelectCellAtIndexPath:(NSIndexPath *)indexPath;
- (id<FormItemProtocol>)itemForCellByIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectCell:(UITableViewCell *)cell;
- (void)updateItem:(id<FormItemProtocol>)item forIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;
- (NSString *)cancelTitle;
- (NSString *)submitTitle;
- (NSString *)formTitle;

- (NSString *)xmlString;
@end
