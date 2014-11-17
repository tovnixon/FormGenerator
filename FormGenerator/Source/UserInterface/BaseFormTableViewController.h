//
//  BaseFormTableViewController.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/11/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormItemSelectionTableViewController.h"


@class BaseFormDataSource;
@protocol FormViewControllerDelegate;

@interface BaseFormTableViewController : UITableViewController <UIAlertViewDelegate, UITableViewDelegate, FormItemOptionTableViewControllerDelegate>
@property (nonatomic, strong) BaseFormDataSource * dataSource;
@property (nonatomic, weak) id <FormViewControllerDelegate> delegate;
@end

@protocol FormViewControllerDelegate
@required
- (void)formControllerDidCancelForm:(BaseFormTableViewController *)controller;
- (void)formController:(BaseFormTableViewController *)controller didSubmitForm:(NSString *)xmlForm;

@end

