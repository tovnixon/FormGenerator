//
//  BaseFormDataSource.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "BaseFormDataSource.h"
#import "FormProtocol.h"
#import "BaseForm.h"
#import "FormItemCellFactory.h"
#import "FormItemCellProtocol.h"
#import "FormItemProtocol.h"
#import "FormValidator.h"
#import "FormConfigurator.h"

@interface BaseFormDataSource() {
    BOOL _shouldValidateAllCells;
    BOOL _allCellsAreValid;
}
@property (nonatomic, copy) NSString * formTitle;
@property (nonatomic, copy) NSString * cancelTitle;
@property (nonatomic, copy) NSString * submitTitle;
@property (nonatomic, strong) NSMutableDictionary * cellClasses;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic) FormValidator * validator;
@property (nonatomic) FormConfigurator * configurator;
@end

@implementation BaseFormDataSource

- (id)initWithForm:(id<FormProtocol>)aForm {
    self = [super init];
    if (self) {
        self.cellClasses = [NSMutableDictionary new];
        if ([aForm conformsToProtocol:@protocol(FormProtocol)]) {
            self.cancelTitle = aForm.cancelButton;
            self.submitTitle = aForm.submitButton;
            self.formTitle   = aForm.title;
            self.configurator = [[FormConfigurator alloc] initWithForm:aForm];
            self.items = [self.configurator linearedItems];
            self.validator = [[FormValidator alloc] initWithItems:self.items];
        }
    }
    return self;
}

- (BOOL)shouldSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    id <FormItemProtocol> formItem = [self.items[indexPath.section] objectAtIndex:indexPath.row];
    return (formItem.type == FormItemTypeSingleSelection ||
            formItem.type == FormItemTypeMultipleSelection);
}

- (id<FormItemProtocol>)itemForCellByIndexPath:(NSIndexPath *)indexPath {
    id <FormItemProtocol> formItem = [self.items[indexPath.section] objectAtIndex:indexPath.row];
    return formItem;
}

- (void)updateItem:(id<FormItemProtocol>)item forIndexPath:(NSIndexPath *)indexPath {
    id <FormItemProtocol> formItem = [self itemForCellByIndexPath:indexPath];
    formItem = item;
}

- (void)didSelectCell:(UITableViewCell *)cell {
    if ([cell conformsToProtocol:@protocol(FormItemCellProtocol)]) {
        [cell becomeFirstResponder];
    }
}

- (id<FormItemProtocol>)itemByKey:(NSString *)aKey {
    for (NSArray * section in self.items) {
        for (id<FormItemProtocol> item in section) {
            if ([item.key isEqualToString:aKey])
                return item;
        }
    }
    return nil;
}

#pragma mark - FormItemCell delegate
- (void)cellValueChanged:(id<FormItemCellProtocol>)cell {
    id <FormItemProtocol> item = [self itemByKey:[cell dataSourceKey]];
    //set value from user input to model
    NSDictionary * dict = [cell keyedValue];
    item.storedValue = [dict valueForKey:kValidationValueKey];
    [self validateCell:cell];
    
    if (item.type == FormItemTypeAgree) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAgreeChangedNotification" object:nil
                                                          userInfo:dict];
    }
}

- (void)accessoryTappedInCell:(id<FormItemCellProtocol>)cell {
    
}

#pragma mark - Validation
- (BOOL)validateCell:(id<FormItemCellProtocol>)cell {
    __block BOOL valid = YES;
    NSDictionary * dict = [cell keyedValue];
    NSLog(@"Answer: %@", dict);
    NSString * key = [dict objectForKey:kValidationKeyKey];
    NSString * value = [dict objectForKey:kValidationValueKey];
    [self.validator validateValue:value forKey:key result:^(NSString *errorMessage, BOOL success) {
        [cell updateValidationInfo:errorMessage valid:success];
        valid = success;
    }];
    return valid;
}

- (BOOL)validateValuesIn:(UITableView *)tableView {
    __block BOOL valid = YES;
    _shouldValidateAllCells = YES;
    for (NSArray * section in self.items) {
        for (id<FormItemProtocol> formItem in section) {
            NSString * value = formItem.storedValue ? formItem.storedValue : formItem.defaultValue;
            [self.validator validateValue:value forKey:[formItem bindingKey] result:^(NSString *errorMessage, BOOL success) {
                //one fail result is enough
                if (!success && valid) {
                    valid = NO;
                }
            }];
        }
    }
    return valid;
}

- (NSString *)xmlString {
    return [self.configurator xmlStringWithItems:self.items];
}

#pragma mark - cell height
- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    static UITableViewCell <FormItemCellProtocol> * sizingCell = nil;

    id <FormItemProtocol> item = self.items[indexPath.section][indexPath.row];
    Class clazz = [[FormItemCellFactory defaultFactory] cellClassForFormItem:item];
    NSString * identifier = NSStringFromClass(clazz);
    // cellClasses store @{key=reusableCellIdentifier : object=respective cell}
    if ([self.cellClasses.allKeys containsObject:identifier]) {
        sizingCell = [self.cellClasses objectForKey:identifier];
    } else {
        sizingCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        [self.cellClasses setObject:sizingCell forKey:identifier];
    }
    [sizingCell configureWithFormItem:item];
    
    [sizingCell setNeedsUpdateConstraints];
    [sizingCell updateConstraintsIfNeeded];
    
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(sizingCell.bounds));
    [sizingCell.contentView setNeedsLayout];
    [sizingCell.contentView layoutIfNeeded];

//    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    NSLog(@"%f", size.height);
    CGSize size = [sizingCell calculateSize:tableView.bounds.size];
    return size.height;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.items[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * arrSection = self.items[indexPath.section];
    id <FormItemProtocol> formItem = [arrSection objectAtIndex:indexPath.row];
    UITableViewCell <FormItemCellProtocol> *cell = [[FormItemCellFactory defaultFactory] cellWithFormItem:formItem forTableView:tableView];
    //TODO:
    //remove cell separator for group items
    [cell configureWithFormItem:formItem];
    if (_shouldValidateAllCells) {
        [self validateCell:cell];
    }
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.delegate = self;
    return cell;
}

@end
