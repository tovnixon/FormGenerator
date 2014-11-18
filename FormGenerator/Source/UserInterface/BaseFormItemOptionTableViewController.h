//
//  BaseFormItemOptionTableViewController.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/13/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FormItemOptionTableViewControllerDelegate;

@interface BaseFormItemOptionTableViewController : UITableViewController
@property (nonatomic, weak) IBOutlet UIBarButtonItem * btnDone;

@property (nonatomic, weak) id <FormItemOptionTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray * options;
@property (nonatomic, strong) NSMutableArray * selectedOptions;
@property (nonatomic, strong) NSMutableArray * selectedIndexes;
@property (nonatomic, strong) NSString * title;

- (void)configure:(NSArray *)anOptions title:(NSString *)title selected:(NSArray *)selected;
- (IBAction)done:(id)sender;
- (NSArray *)resultSelection;
@end

@protocol FormItemOptionTableViewControllerDelegate
- (void)controller:(id)controller didFinishWithOptions:(NSArray *)options;

@end;
