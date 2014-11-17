//
//  MappingPair.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/11/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MappingPair : NSObject
@property (nonatomic, strong, readonly) NSString *keyFrom, *keyTo;
+ (instancetype)pairKey:(NSString *)aKeyFrom to:(NSString *)aKeyTo;
@end
