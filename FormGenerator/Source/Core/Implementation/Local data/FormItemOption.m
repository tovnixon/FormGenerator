//
//  FormItemOption.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/13/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "FormItemOption.h"

@interface FormItemOption()
@property (nonatomic, copy) NSString * value;
@property (nonatomic, copy) NSString * title;
@end

@implementation FormItemOption

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    FormItemOption * copy = [[self class] allocWithZone:zone];
    copy.title = self.title;
    copy.value = self.value;
    return copy;
}

+ (id)optionWithTitle:(NSString *)aTitle value:(NSString *)aValue {
    FormItemOption * fio = [FormItemOption new];
    fio.value = aValue;
    fio.title = aTitle;
    return fio;
}

- (NSString *)displayTitle {
    return self.title ? self.title : self.value;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToVendor:other];
}

- (BOOL)isEqualToVendor:(FormItemOption *)anOption {
    if (self == anOption)
        return YES;
    if (![(id)[self value] isEqual:[anOption value]])
        return NO;
    return YES;
}

//- (NSString *)description {
//    return [NSString stringWithFormat:@"FormItemOption: <title = %@, value = %@>", self.title, self.value];
//}
@end
