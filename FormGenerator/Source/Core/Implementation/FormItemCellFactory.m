//
//  FormItemCellFactory.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "FormItemCellFactory.h"
#import "FormItemCells.h"
#import "FormItemCellProtocol.h"
#import "FormItemProtocol.h"

@interface FormItemCellFactory()
@property (nonatomic) NSDictionary * classesByItemType;
@end

@implementation FormItemCellFactory

- (id)init {
    self = [super init];
    if (self) {
        Class boolCellClass = [BoolFormItemCell class];
        Class labelCellClass = [LabelFormItemCell class];
        Class textfieldCellClass = [TextFieldFormItemCell class];
        Class textviewCellClass = [TextAreaFormItemCell class];
        Class singleSelectionCellClass = [SingleSelectionFormItemCell class];
        Class groupHeaderCellClass = [GroupHeaderItemCell class];
        Class agreeCellClass = [AgreeFormItemCell class];
        Class descriptionCellClass = [FormDescriptionCell class];
        self.classesByItemType = @{FormItemTypeLabel:[NSSet setWithObject:labelCellClass],
                                   FormItemTypeNestedGroup:[NSSet setWithObject:groupHeaderCellClass],
                                   FormItemTypeText:[NSSet setWithObject:textfieldCellClass],
                                   FormItemTypeTextArea:[NSSet setWithObject:textviewCellClass],
                                   FormItemTypeSingleSelection:[NSSet setWithObject:singleSelectionCellClass],
                                   FormItemTypeSingleSelectionSmart:[NSSet setWithObject:labelCellClass],
                                   FormItemTypeAgree:[NSSet setWithObject:agreeCellClass],
                                   FormItemTypeDescription:[NSSet setWithObject:descriptionCellClass],
                                   FormItemTypeCheckBox:[NSSet setWithObject:boolCellClass],
                                   FormItemTypeConverter:[NSSet setWithObject:labelCellClass],
                                   FormItemTypeArray:[NSSet setWithObject:groupHeaderCellClass]};
    }
    return self;
}

+ (FormItemCellFactory *)defaultFactory {
    static FormItemCellFactory * factory = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        factory = [FormItemCellFactory new];
    });
    return factory;
}

- (Class)cellClassForFormItem:(id <FormItemProtocol>)formItem {
    NSMutableSet *set = [NSMutableSet setWithSet:[self.classesByItemType objectForKey:formItem.type]];
    return [set anyObject];
}

- (UITableViewCell <FormItemCellProtocol> *)cellWithFormItem:(id <FormItemProtocol>)formItem forTableView:(UITableView *)tableView {
    Class clazz = [self cellClassForFormItem:formItem];
    NSString *cellID = NSStringFromClass(clazz);
    UITableViewCell <FormItemCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    return cell;
}

- (void)registerAllCellsInTableView:(UITableView *)tableView {

}
@end
