//
//  FormItemSelectionTableViewController.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/14/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "FormItemSelectionTableViewController.h"

@interface FormItemSelectionTableViewController()
@property BOOL multipleSelection;
@end

@implementation FormItemSelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.multipleSelection) {
        self.btnDone = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)configure:(NSArray *)anOptions title:(NSString *)title selected:(NSArray *)selected multiple:(BOOL)multipleSelection {
    [super configure:anOptions title:title selected:selected];
    self.multipleSelection = multipleSelection;
    self.tableView.allowsMultipleSelection = self.multipleSelection;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if (self.multipleSelection) {
        if (![self.selectedIndexes containsObject:indexPath]) {
            [self.selectedIndexes addObject:indexPath];
        }
    } else {
        [self.selectedIndexes removeAllObjects];
        [self.selectedIndexes addObject:indexPath];
        [self.delegate controller:self didFinishWithOptions:[self resultSelection]];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didDeselectRowAtIndexPath:indexPath];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([self.selectedIndexes containsObject:indexPath]) {
        [self.selectedIndexes removeObject:indexPath];
    }
}

@end
