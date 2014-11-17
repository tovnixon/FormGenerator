//
//  BaseFormItemOptionTableViewController.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/13/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "BaseFormItemOptionTableViewController.h"
@interface BaseFormItemOptionTableViewController()
@end

@implementation BaseFormItemOptionTableViewController
static NSString * cellIdentifier = @"FormItemOptionCell";
- (void)configure:(NSArray *)anOptions title:(NSString *)title selected:(NSArray *)selected {
    self.selectedIndexes = [NSMutableArray new];
    self.options = anOptions;
    self.selectedOptions = [NSMutableArray new];
    [self.selectedOptions addObjectsFromArray:selected];
    self.title = title;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.title;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (NSArray *)resultSelection {
    NSMutableArray * result = [NSMutableArray new];
    for (NSIndexPath * index in self.selectedIndexes) {
        NSString * value = self.options[index.row];
        [result addObject:value];
    }
    return [NSArray arrayWithArray:result];
}

- (IBAction)done:(id)sender {
    [self.delegate controller:self didFinishWithOptions:[self resultSelection]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString * option = self.options[indexPath.row];
    cell.textLabel.text = option;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    if ([self.selectedOptions containsObject:option]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[self selectedIndexes] addObject:indexPath];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}
@end
