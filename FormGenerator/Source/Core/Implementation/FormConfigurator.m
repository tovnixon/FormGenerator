//
//  FormConfigurator.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/14/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "FormConfigurator.h"
#import "BaseFormItem.h"
#import "GroupFormItem.h"
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
    //add header item, form description
    
    if (self.form.formDescription) {
        id <FormItemProtocol> descriptionItem = [[BaseFormItem alloc] initWithType:FormItemTypeDescription name:@"Description" value:self.form.formDescription description:nil pageId:nil];
        [self.items addObject:@[descriptionItem]];
    }
    NSMutableArray * destinationItems = [@[] mutableCopy];
    [self linearItemsFromArray:self.form.items toArray:destinationItems parentKey:nil];
    [self.items addObject:[NSArray arrayWithArray:destinationItems]];
    
    if (self.form.agreeText) {
        id <FormItemProtocol> descriptionItem = [[BaseFormItem alloc] initWithType:FormItemTypeAgree name:@"Agreee" value:self.form.agreeText description:nil pageId:nil];
        [self.items addObject:@[descriptionItem]];
    }
}

- (void)linearItemsFromArray:(NSArray *)source toArray:(NSMutableArray *)destination parentKey:(NSString *)parentKey{
    for (id <FormItemProtocol> item in source) {
        if ([item conformsToProtocol:@protocol(GroupFormItemProtocol)]) {
            GroupFormItem * groupHeader = [[GroupFormItem alloc] initWithType:item.type name:item.name value:item.label description:item.itemDescription pageId:nil];
            groupHeader.parentKey = parentKey;
            [groupHeader setSubItems:[(GroupFormItem *)item subItems]];
            [destination addObject:groupHeader];
            
            [self linearItemsFromArray:[(GroupFormItem *)item subItems]  toArray:destination parentKey:groupHeader.key];
        } else {
            if (parentKey) {
                item.parentKey = parentKey;
            }
            [destination addObject:item];
        }
    }
}

- (NSArray *)structuredItemsFrom:(NSArray *)linearItems {
    NSMutableArray * result = [NSMutableArray new];
    for (id<FormItemProtocol> item in linearItems) {
        if ([item respondsToSelector:@selector(subItems)]) {
            NSArray * linearSubItems = [self itemsWithParent:[item key] fromArray:linearItems];
            if ([self array:linearSubItems containsItemsResponded:@selector(subItems)]) {
                [self structuredItemsFrom:linearSubItems];
            } else {
                
                if (linearSubItems.count) {
                    //very deep level of tree
                    [(id<GroupFormItemProtocol>)item setSubItems:linearSubItems];
                    
                }
                //remove linear sub items and linearitems
            }
        } else {
            [result addObject:item];
        }
    }
    return [NSArray arrayWithArray:result];
}

- (BOOL)array:(NSArray *)array containsItemsResponded:(SEL)selector {
    for (id <FormItemProtocol> item in array) {
        if ([item respondsToSelector:selector])
            return YES;
    }
    return NO;
}

- (id<FormItemProtocol>)itemByKey:(NSString *)key fromArray:(NSArray *)array {
    for (id<FormItemProtocol> item in array) {
        if ([item.key isEqualToString:key])
            return item;
    }
    return nil;

}
- (NSArray *)itemsWithParent:(NSString *)parentKey fromArray:(NSArray *)array {
    NSMutableArray * result = [@[] mutableCopy];
    for (id<FormItemProtocol> item in array) {
        if ([item.parentKey isEqualToString:parentKey]) {
            [result addObject:item];
        }
    }
    return result;
}

- (NSString *)xmlStringWithItems:(NSArray *)linearItems {
    NSMutableArray * structuredItems = [@[] mutableCopy];

    //enumerate sections
    
    //remove duplication
    for (NSArray * section in linearItems) {
        for (id<FormItemProtocol> item in section) {
            if (![item hasParent])
                [structuredItems addObject:item];
        }
    }

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
