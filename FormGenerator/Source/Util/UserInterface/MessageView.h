//
//  MessageView.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/17/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MessageViewDelegate
- (void)didHide;
@end
typedef void (^HidingCompletionBlock)();
@interface MessageView : UIView
@property (nonatomic, weak) id <MessageViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame message:(NSString *)aMessage;
- (id)initWithMessage:(NSString *)aMessage;
- (void)updateWithMessage:(NSString *)aMessage;
- (void)hideAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated completion:(HidingCompletionBlock)block;
@end
