//
//  FormItemCellFactory.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//
#import <UIKit/UITableView.h>
#import <UIKit/UITableViewCell.h>
#import <Foundation/Foundation.h>
@protocol FormItemProtocol;
@protocol FormItemCellProtocol;

@interface FormItemCellFactory : NSObject
+ (FormItemCellFactory *)defaultFactory;

- (Class)cellClassForFormItem:(id <FormItemProtocol>)formItem;
- (UITableViewCell <FormItemCellProtocol> *)cellWithFormItem:(id <FormItemProtocol>)formItem forTableView:(UITableView *)tableView;
- (void)registerAllCellsInTableView:(UITableView *)tableView;

@end
