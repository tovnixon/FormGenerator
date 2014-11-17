//
//  FormItemSelectionTableViewController.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/14/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "BaseFormItemOptionTableViewController.h"

@interface FormItemSelectionTableViewController : BaseFormItemOptionTableViewController

#warning TODO: refactor (provide convinient interface for multiple and single selection, decompose this class, separate datasource)
- (void)configure:(NSArray *)anOptions title:(NSString *)title selected:(NSArray *)selected multiple:(BOOL)multipleSelection;
@end
