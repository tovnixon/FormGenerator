//
//  MappingPair.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/11/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "MappingPair.h"

@interface MappingPair()
@property (nonatomic, strong) NSString *keyFrom, *keyTo;
@end

@implementation MappingPair
+ (instancetype)pairKey:(NSString *)aKeyFrom to:(NSString *)aKeyTo {
    MappingPair * mp = [MappingPair new];
    mp.keyFrom = aKeyFrom;
    mp.keyTo   = aKeyTo;
    return mp;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Mapping pair: keyFrom = %@, keyTo = %@>", self.keyFrom, self.keyTo];
}
@end
