//
//  BaseFormItem+Protected.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/16/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "BaseFormItem.h"
#import "DDXMLDocument.h"
#ifndef FormGenerator_BaseFormItem_Protected_h
#define FormGenerator_BaseFormItem_Protected_h

@interface BaseFormItem()
@property (nonatomic, strong) NSMutableArray * maping;

- (instancetype)initWithType:(NSString *)aType name:(NSString *)aName value:(NSString *)aValue description:(NSString *)aDescription pageId:(NSString *)aPageId;
- (void)serializeFromDictionary:(NSDictionary *)dictionary;
- (void)createBindingKey;



@end
#endif
