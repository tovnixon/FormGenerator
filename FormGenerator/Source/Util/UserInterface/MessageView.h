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
- (void)didShow;
@end
typedef void (^HidingCompletionBlock)();
@interface MessageView : UIView
@property (nonatomic, weak) IBOutlet id <MessageViewDelegate> delegate;

- (void)updateWithMessage:(NSString *)aMessage;
- (void)silentShow;
- (void)show;
- (void)hide;
- (void)silentHide;
@end
