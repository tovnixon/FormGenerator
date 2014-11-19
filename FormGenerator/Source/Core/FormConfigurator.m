//
//  FormConfigurator.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/14/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "FormConfigurator.h"
#import "BaseFormItem.h"
#import "BaseFormItem+Protected.h"
#import "BaseForm+Protected.h"
@interface FormConfigurator()
@property (nonatomic, strong) id <FormProtocol> form;
@property (nonatomic, strong) NSMutableArray * items;
@end

@implementation FormConfigurator


- (id)initWithForm:(id<FormProtocol>)aForm {
    self = [super init];
    if (self) {
        self.form = aForm;
        self.items = [NSMutableArray new];
        [self configureForDispayingInTableView];
    }
    return self;
}

- (void)configureForDispayingInTableView {
    NSMutableArray * array = [NSMutableArray new];
    //add header item, form description
    
    if (self.form.formDescription) {
        id <FormItemProtocol> descriptionItem = [[BaseFormItem alloc] initWithType:FormItemTypeDescription name:@"Description" value:self.form.formDescription description:nil];
        descriptionItem.validatable = NO;
        [self.items addObject:@[descriptionItem]];
    }
    //add all fields
    for (id <FormItemProtocol> item in self.form.items) {
        if (item.type == FormItemTypeNestedGroup) {
            [self.items addObject:[array copy]];
            [array removeAllObjects];
            
            //create label item from item and add it
            BaseFormItem * groupHeader = [[BaseFormItem alloc] initWithType:FormItemTypeNestedGroup name:item.name value:item.label description:item.itemDescription];
            for (id <FormItemProtocol> subItem in item.subItems) {
                subItem.parentKey = groupHeader.key;
                [groupHeader.children addObject:subItem.key];
                [array addObject:subItem];
            }
            [array insertObject:groupHeader atIndex:0];
            //
            [self.items addObject:[array copy]];
            [array removeAllObjects];
        } else {
            [array addObject:item];
        }
    }
    
    [self.items addObject:[array copy]];
    [array removeAllObjects];
    //add agree text
    if (self.form.agreeText) {
        id <FormItemProtocol> descriptionItem = [[BaseFormItem alloc] initWithType:FormItemTypeAgree name:@"Agreee" value:self.form.agreeText description:nil];
        descriptionItem.validatable = NO;
        [self.items addObject:@[descriptionItem]];
    }

}

- (NSArray *)structuredItemsFrom:(NSArray *)linearItems {
    NSMutableArray * result = [NSMutableArray new];
    for (NSArray * section in linearItems) {
        for (id<FormItemProtocol> item in section) {
            if (item.type == FormItemTypeNestedGroup) {
                //root object
                NSMutableArray * subItems = [NSMutableArray arrayWithArray:section];
                [subItems removeObjectAtIndex:0];
                item.subItems = subItems;
                break;
            } else {
                [result addObject:item];
            }
        }
    }
    //remove form description
    [result removeObjectAtIndex:0];
    //remove agree text
    [result removeLastObject];
    return [NSArray arrayWithArray:result];
}


- (NSString *)xmlStringWithItems:(NSArray *)linearItems {
    
    NSArray * structuredItems = [self structuredItemsFrom:linearItems];
    id <FormProtocol> newForm = [[BaseForm alloc] initWithForm:self.form withItems:structuredItems];
    NSString * result = [newForm xmlString];
    return result;
}

- (NSString *)cancelTitle {
    return self.form.cancelButton;
}

- (NSString *)submitTitle {
    return self.form.submitButton;
}

- (NSString *)formTitle {
    return self.form.title;
}

- (NSArray *)linearedItems {
    return [self.items copy];
}

@end
