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

#define EnableCellHeigthCash
@interface BaseFormDataSource() {
    BOOL _shouldValidateAllCells;
    BOOL _allCellsAreValid;
}
@property (nonatomic, copy) NSString * formTitle;
@property (nonatomic, copy) NSString * cancelTitle;
@property (nonatomic, copy) NSString * submitTitle;

@property (nonatomic, strong) NSMutableDictionary * cellClasses;
@property (nonatomic, strong) NSMutableDictionary * cellHeigthCash;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic) FormValidator * validator;
@property (nonatomic) FormConfigurator * configurator;
@end

@implementation BaseFormDataSource

- (id)initWithForm:(id<FormProtocol>)aForm {
    self = [super init];
    if (self) {
        self.cellClasses = [@{} mutableCopy];
        self.cellHeigthCash = [NSMutableDictionary new];
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
    return ([formItem.type isEqualToString:FormItemTypeSingleSelection] ||
            [formItem.type isEqualToString:FormItemTypeMultipleSelection]);
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
- (void)cellValueChanged:(id<FormItemCellProtocol>)cell {
    id <FormItemProtocol> item = [self itemByKey:[cell dataSourceKey]];
    //set value from user input to model
    NSDictionary * dict = [cell keyedValue];
    [item setShouldValidate:YES];
    [item setValue:[dict valueForKey:kValidationValueKey]];
    [item setDisplayErrorMessage:[[dict valueForKey:kShowInfoKey] boolValue]];

    if ([item.type isEqualToString:FormItemTypeAgree]) {
        for (NSArray * sections in self.items) {
            for (id<FormItemProtocol> item in sections) {
                [item setShouldValidate:YES];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAgreeChangedNotification" object:nil
                                                          userInfo:dict];
    } else {
        [self.cellHeigthCash removeObjectForKey:[item bindingKey]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CellContentChangedNotification" object:nil
                                                          userInfo:@{@"Cell" : cell}];
    
    }
}


- (void)accessoryTappedInCell:(id<FormItemCellProtocol>)cell {
    
}

#pragma mark - Validation
- (BOOL)validateValuesIn:(UITableView *)tableView {
    for (NSArray * section in self.items) {
        for (id<FormItemProtocol> formItem in section) {
            //one fail result is enough
            if (![formItem isValid])
                return NO;
        }
    }
    return YES;
}

- (NSString *)xmlString {
    return [self.configurator xmlStringWithItems:self.items];
}

#pragma mark - cell height

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    id <FormItemProtocol> item = self.items[indexPath.section][indexPath.row];
#ifdef EnableCellHeigthCash
    NSNumber * cellHeight = self.cellHeigthCash[[item bindingKey]];
    if (cellHeight != nil) {
        return [cellHeight floatValue];
    } else {

    }
#endif
    CGFloat height = [self calculateForCellAtPath:indexPath inTableView:tableView];
//    NSLog(@"%2.0f", height);
#ifdef EnableCellHeigthCash
    self.cellHeigthCash[[item bindingKey]] = @(height);
#endif
    return height;
}

- (CGFloat)calculateForCellAtPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
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
    
    [sizingCell configureWithFormItem:item delegate:nil];
    [sizingCell layoutIfNeeded];
    
    if ([item.type isEqualToString:FormItemTypeDescription] ||
        [item.type isEqualToString:FormItemTypeAgree]) {
        CGSize s = [sizingCell calculateSize:CGSizeZero];
        return s.height + 1;
    }
    
    CGFloat height = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 1;
    return height;
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
    [cell configureWithFormItem:formItem delegate:self];
    cell.delegate = self;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    if (cell == nil) {
        NSLog(@"dasd");
    }
    return cell;
}

@end
