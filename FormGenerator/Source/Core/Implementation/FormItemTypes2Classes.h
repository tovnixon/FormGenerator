//
//  FormItemTypes2Classes.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/23/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormItemTypes2Classes : NSObject

+ (FormItemTypes2Classes *)sharedInstance;
- (Class)formItemClassByType:(NSString *)formItemType;
@end
