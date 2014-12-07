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
    [self linearItemsFromArray:self.form.items toArray:destinationItems parentKey:nil level:0];
    [self.items addObject:[NSArray arrayWithArray:destinationItems]];
    
    if (self.form.agreeText) {
        id <FormItemProtocol> descriptionItem = [[BaseFormItem alloc] initWithType:FormItemTypeAgree name:@"Agreee" value:self.form.agreeText description:nil pageId:nil];
        [self.items addObject:@[descriptionItem]];
    }
}

- (void)linearItemsFromArray:(NSArray *)source toArray:(NSMutableArray *)destination parentKey:(NSString *)parentKey level:(int)level {
    for (id <FormItemProtocol> item in source) {
        if ([item conformsToProtocol:@protocol(GroupFormItemProtocol)]) {
            GroupFormItem * groupHeader = [[GroupFormItem alloc] initWithType:item.type name:item.name value:item.label description:item.itemDescription pageId:nil level:[NSNumber numberWithInt:level]];
            groupHeader.parentKey = parentKey;
            [destination addObject:groupHeader];
            [self linearItemsFromArray:[(GroupFormItem *)item subItems]  toArray:destination parentKey:groupHeader.key level:level + 1];
        } else {
            if (parentKey) {
                item.parentKey = parentKey;
                item.level = [NSNumber numberWithInt:level];
            }
            [destination addObject:item];
        }
    }
}

- (void)structureItemsFromArray:(NSArray *)source toArray:(NSMutableArray *)destination level:(int)level parent:(NSString *)parentKey {
    for (id <FormItemProtocol> item in source) {
        if ([item.level intValue] == level) {
            if (!parentKey)
                [destination addObject:item];
            else
                if ([item.parentKey isEqualToString:parentKey])
                    [destination addObject:item];
                
            if ([item respondsToSelector:@selector(subItems)]) {
                NSMutableArray * subItems = [@[] mutableCopy];
                [self structureItemsFromArray:source toArray:subItems level:level + 1 parent:item.key];
                [(GroupFormItem *)item setSubItems:subItems];
            }
        }
    }
}
- (NSString *)xmlStringWithItems:(NSArray *)linearItems {
    NSMutableArray * structuredItems = [@[] mutableCopy];
    for (NSArray * section in linearItems) {
        [self structureItemsFromArray:section toArray:structuredItems level:0 parent:nil];
    }
    id <FormProtocol> newForm = [[BaseForm alloc] initWithForm:self.form withItems:structuredItems];
    NSString * result = [newForm xmlString];
//http://codebeautify.org/xmlviewer#
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
