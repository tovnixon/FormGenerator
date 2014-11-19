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
#import "FormDescriptionCell.h"
#import "TextAreaFormItemCell.h"

@interface BaseFormDataSource() {
    BOOL _shouldValidateAllCells;
    BOOL _allCellsAreValid;
}
@property (nonatomic, copy) NSString * formTitle;
@property (nonatomic, copy) NSString * cancelTitle;
@property (nonatomic, copy) NSString * submitTitle;

@property (nonatomic, strong) NSMutableDictionary * cellClasses;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) NSMutableSet * itemsWithInfo;
@property (nonatomic, strong) NSMutableDictionary * textViews;
@property (nonatomic) FormValidator * validator;
@property (nonatomic) FormConfigurator * configurator;
@end

@implementation BaseFormDataSource

- (id)initWithForm:(id<FormProtocol>)aForm {
    self = [super init];
    if (self) {
        self.cellClasses = [@{} mutableCopy];
        self.itemsWithInfo = [NSMutableSet new];
        self.textViews = [@{} mutableCopy];
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

- (NSIndexPath *)indexPathForItemByKey:(NSString *)key {
    int section = 0, row = 0;
    for (NSArray * sections in self.items) {
        for (id<FormItemProtocol> item in sections) {
            if ([item.key isEqualToString:key]) {
                return [NSIndexPath indexPathForRow:row inSection:section];
            }
            row++;
        }
        section++;
    }
    return nil;
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
- (void)cellValueChanged:(id<FormItemCellProtocol>)cell validationRequired:(BOOL)shouldValidate {
    id <FormItemProtocol> item = [self itemByKey:[cell dataSourceKey]];
    //set value from user input to model
    NSDictionary * dict = [cell keyedValue];
    item.storedValue = [dict valueForKey:kValidationValueKey];
    NSNumber * valid = [dict valueForKey:kIsValidKey];
    item.valid = [valid boolValue];
    
    if (shouldValidate) {
        [self validateCell:cell];
    } else {
    }
    
    if (item.type == FormItemTypeAgree) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAgreeChangedNotification" object:nil
                                                          userInfo:dict];
    }
}

- (void)heightChangedInCell:(id<FormItemCellProtocol>)cell grow:(BOOL)grow {
   id <FormItemProtocol> item = [self itemByKey:[cell dataSourceKey]];
    if (grow)
        [self.itemsWithInfo addObject:item];
    else {
        [self.itemsWithInfo removeObject:item];
    }
    NSIndexPath * ipToReload = [self indexPathForItemByKey:[cell dataSourceKey]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellHeightChangedNotification" object:nil
                                                      userInfo:@{@"item" : ipToReload}];
    
}

- (void)accessoryTappedInCell:(id<FormItemCellProtocol>)cell {
    
}

#pragma mark - Validation
- (BOOL)validateCell:(id<FormItemCellProtocol>)cell {
    __block BOOL valid = YES;
    __block NSString * message;
    NSDictionary * dict = [cell keyedValue];
    NSLog(@"Answer: %@", dict);
    NSString * key = [dict objectForKey:kValidationKeyKey];
    NSString * value = [dict objectForKey:kValidationValueKey];
    [self.validator validateValue:value forKey:key result:^(NSString *errorMessage, BOOL success) {
        valid = success;
        message = errorMessage;
    }];
    id <FormItemProtocol> item = [self itemByKey:[cell dataSourceKey]];
    item.valid = valid;
    item.errorMessage = message;
    [cell updateValidationInfo:message valid:valid];
    NSIndexPath * ipToReload = [self indexPathForItemByKey:[cell dataSourceKey]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellHeightChangedNotification" object:nil
                                                      userInfo:@{@"item" : ipToReload}];
   
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

- (CGFloat)textViewHeightForRowAtIndexPath: (NSIndexPath*)indexPath {
    id <FormItemProtocol> item = self.items[indexPath.section][indexPath.row];

    UITextView *calculationView = [self.textViews objectForKey: indexPath];
    CGFloat textViewWidth = calculationView.frame.size.width;
    if (!calculationView.text) {
        // This will be needed on load, when the text view is not inited yet
        
        calculationView = [[UITextView alloc] init];
        calculationView.text = [item storedValue] ? [item storedValue] : [item defaultValue]; // get the text from your datasource add attributes and insert here
        textViewWidth = 200; // Insert the width of your UITextViews or include calculations to set it accordingly
    }
    CGSize size = [calculationView sizeThatFits:CGSizeMake(textViewWidth, FLT_MAX)];
    return size.height;
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    id <FormItemProtocol> item = self.items[indexPath.section][indexPath.row];
    static UITableViewCell <FormItemCellProtocol> * sizingCell = nil;


    Class clazz = [[FormItemCellFactory defaultFactory] cellClassForFormItem:item];
    NSString * identifier = NSStringFromClass(clazz);
    
    // cellClasses store @{key=reusableCellIdentifier : object=respective cell}
    if ([self.cellClasses.allKeys containsObject:identifier]) {
        sizingCell = [self.cellClasses objectForKey:identifier];
    } else {
        sizingCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        [self.cellClasses setObject:sizingCell forKey:identifier];
    }
    
    BOOL shoulShowInfo = [self.itemsWithInfo containsObject:item];
    [sizingCell configureWithFormItem:item showInfo:shoulShowInfo delegate:nil];
    [sizingCell layoutIfNeeded];
    if (item.type == FormItemTypeTextArea) {
        CGSize s = [sizingCell calculateSize:CGSizeZero];
        return s.height + 1;
    } else {
    
    }
    CGFloat height = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    if ([identifier isEqualToString:@"FormDescriptionCell"]) {
        height = [(FormDescriptionCell *)sizingCell height];
    }

    return height + 1;
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
    BOOL shoulShowInfo = [self.itemsWithInfo containsObject:formItem];

    [cell configureWithFormItem:formItem showInfo:shoulShowInfo delegate:self];
    cell.delegate = self;
    if (formItem.type == FormItemTypeTextArea) {
        [self.textViews setObject:[(TextAreaFormItemCell *)cell tvInput] forKey:indexPath];
    }
    
    if (_shouldValidateAllCells) {
//        [self validateCell:cell];
    }
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];

    return cell;
}

@end
