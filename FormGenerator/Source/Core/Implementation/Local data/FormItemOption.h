//
//  FormItemOption.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/13/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormItemOption : NSObject <NSCopying>
@property (nonatomic, copy, readonly) NSString * title;
@property (nonatomic, copy, readonly) NSString * value;
+ (id)optionWithTitle:(NSString *)aTitle value:(NSString *)aValue;
- (NSString *)displayTitle;
@end
