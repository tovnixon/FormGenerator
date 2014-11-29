//
//  FormValidator.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "FormValidator.h"
#import "FormItemProtocol.h"
#import "FormProtocol.h"

@interface Validator : NSObject
@property (nonatomic) NSRegularExpression * regex;
@property (nonatomic, copy) NSString * errorDescription;
+ (Validator *)validatorWithRule:(NSRegularExpression *)rule description:(NSString *)description;
@end

@implementation Validator

+ (Validator *)validatorWithRule:(NSRegularExpression *)rule description:(NSString *)description {
    Validator * v = [Validator new];
    v.regex = rule;
    v.errorDescription = description;
    return v;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToValidator:other];
}

- (BOOL)isEqualToValidator:(Validator *)aValidator {
    if (self == aValidator)
        return YES;
    if (![(id)[self regex] isEqual:[aValidator regex]])
        return NO;
    return YES;
}
@end

@interface FormValidator()
@property (nonatomic) NSMutableArray * arrPatterns;
@property (nonatomic) NSMutableDictionary * patterns;
@end

@implementation FormValidator

- (id)initWithItems:(NSArray *)formItems {
    self = [super init];
    if (self) {
        self.patterns = [NSMutableDictionary new];
        self.arrPatterns = [NSMutableArray new];
        for (NSArray * section in formItems) {
            for (id <FormItemProtocol>formItem in section) {
                //skip readonly fields
                if ([formItem.type isEqualToString:FormItemTypeLabel] ||
                    [formItem.type isEqualToString:FormItemTypeAgree] ||
                    [formItem.type isEqualToString:FormItemTypeDescription] ||
                    [formItem.type isEqualToString:FormItemTypeNestedGroup])
                    continue;
                NSString * key = [formItem bindingKey];
                //specific regex
                NSString * pattern = [formItem validationPattern];
                [self addPattern:pattern forKey:key description:@"Input value have invalid format"];
                //max length
                if ([formItem.maxLength integerValue] > 0 &&
                    ([formItem.type isEqualToString:FormItemTypeText] || [formItem.type isEqualToString:FormItemTypeTextArea])) {
                    NSNumber * maxLength = formItem.maxLength;
                    NSString * maxLengthPattern = [NSString stringWithFormat:@"^.{0,%d}$", [maxLength integerValue]];
                    [self addPattern:maxLengthPattern forKey:key description:[NSString stringWithFormat:@"Max length for this field is %d", [maxLength integerValue]]];
                }
                //mandatory
                //by default all fields are mandatory
                
                if (!formItem.optional) {
                    if (key == nil) {
                        NSLog(@"sd");
                    }

                    NSString * notEmptyPattern = @"^.{1,2049}$";
                    [self addPattern:notEmptyPattern forKey:key description:@"The field is mandatory"];
                }
            }
        }
    }
    return self;
}

- (void)addPattern:(NSString *)pattern forKey:(NSString *)key description:(NSString *)description {
    NSError * error = nil;
    if (!pattern || pattern.length == 0)
        return;
    NSRegularExpression * regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    Validator * v = [Validator validatorWithRule:regex description:description];
    if (!error) {
        NSMutableArray * validators = [self.patterns objectForKey:key];
        if (!validators) {
            validators = [NSMutableArray array];
        }
        if (![validators containsObject:v])
            [validators addObject:v];
        [self.patterns setObject:validators forKey:key];
    } else {
        NSLog(@"can't create regex %@", error.localizedDescription);
    }
}

- (void)validateValue:(NSString *)value forKey:(NSString *)key result:(ValidationResultBlock)resultBlock {
    NSMutableArray * validators = [self.patterns objectForKey:key];
    if (!validators || validators.count == 0) {
        resultBlock(nil, YES);
        return;
    }
    for (Validator * validator in validators) {
        value = value ? value : @"";
        NSTextCheckingResult *match = [validator.regex firstMatchInString:value options:0 range:NSMakeRange(0, [value length])];
        BOOL success = match != nil;
        NSLog(@"validate <%@> which is <%@>, result: %@", key, value, success ? @"success" : @"fail");
        if (!success) {
            resultBlock(validator.errorDescription, success);
            return;
        }
    }
    resultBlock(nil, YES);
}

@end
