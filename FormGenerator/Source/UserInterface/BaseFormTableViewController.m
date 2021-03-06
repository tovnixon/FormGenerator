//
//  BaseFormTableViewController.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/11/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "BaseFormTableViewController.h"
#import "BaseFormDataSource.h"
#import "FormItemProtocol.h"
#import "SelectFormItemProtocol.h"
@interface BaseFormTableViewController ()
@property (nonatomic, strong) id <SelectFormItemProtocol> selectableItem;
#warning form item should be copy, not strong. So you nned to implement NSCopying for FormItem

- (IBAction)submit:(id)sender;
- (IBAction)cancel:(id)sender;
@end

@implementation BaseFormTableViewController
static NSString * formItemOptionsSegue = @"FormItemOptionsSegue";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationItem.title = [self.dataSource formTitle];
    self.navigationItem.rightBarButtonItem.title = [self.dataSource submitTitle];
    self.navigationItem.leftBarButtonItem.title = [self.dataSource cancelTitle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agreeValueChanged:) name:@"UserAgreeChangedNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellContentChanged:) name:@"CellContentChangedNotification" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validateValues {
    return [self.dataSource validateValuesIn:self.tableView];
}

- (void)cellContentChanged:(NSNotification *)notification {
    NSLog(@"cellContentChanged");
    [self.tableView reloadData];
    return;
    NSDictionary * dict = [notification userInfo];
    UITableViewCell * cell = dict[@"Cell"];
    if (cell) {
        NSIndexPath * path = [self.tableView indexPathForCell:cell];
        if (path) {
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
            [self.tableView endUpdates];
        } else {
            [self.tableView reloadData];
        }
    } else {
        [self.tableView reloadData];
    }
    
    NSLog(@"cellContentChanged");
}

- (void)agreeValueChanged:(NSNotification *)notification {
    NSDictionary * dict = [notification userInfo];
    self.navigationItem.rightBarButtonItem.enabled = [[dict valueForKey:@"kValidationValueKey"] isEqualToString:@"true"];
}
#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource heightForBasicCellAtIndexPath:indexPath inTableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.dataSource didSelectCell:cell];
    
    if ([self.dataSource shouldSelectCellAtIndexPath:indexPath]) {
        self.selectableItem = [self.dataSource itemForCellByIndexPath:indexPath];
        [self performSegueWithIdentifier:formItemOptionsSegue sender:self];
    }
}

#pragma mark - Actions

- (IBAction)submit:(id)sender {
    if ([self validateValues]) {
        [self.tableView reloadData];
        NSString * xml = [self.dataSource xmlString];
        NSLog(@"result xml = %@", xml);
        [self.delegate formController:self didSubmitForm:xml];
    } else {
        [self.tableView reloadData];
    }
}

- (IBAction)cancel:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Do you really want to cancel?"
                                                     message:@"you have only 2 more attempts"
                                                    delegate:self cancelButtonTitle:@"No"
                                           otherButtonTitles:@"Yes", nil];
    [alert show];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:[self.delegate formControllerDidCancelForm:self]; break;
        default: break;
    }
}

#pragma mark - FormItemOptionTableViewControllerDelegate 

- (void)controller:(id)controller didFinishWithOptions:(NSArray *)options {
#warning TODO: refactor (wrap logic to model)
    [self.navigationController popToRootViewControllerAnimated:YES];
    if ([self.selectableItem.type isEqualToString:FormItemTypeMultipleSelection]) {
        self.selectableItem.storedValues = options;
    } else {
        self.selectableItem.storedValue = options.count > 0 ? [options objectAtIndex:0] : nil;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:formItemOptionsSegue]) {
        FormItemSelectionTableViewController * optionsVC = segue.destinationViewController;
#warning TODO: refactor (wrap logic to model)
        BOOL multipleSelection = [self.selectableItem.type isEqualToString:FormItemTypeMultipleSelection];
        NSArray * selected = multipleSelection ? self.selectableItem.storedValues :
        @[self.selectableItem.storedValue ? self.selectableItem.storedValue : @""];
        [optionsVC configure:self.selectableItem.options title:self.selectableItem.name selected:selected multiple:multipleSelection];
        optionsVC.delegate = self;
        
    }
}

@end
