//
//  MessageView.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/17/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "MessageView.h"
#import <CoreGraphics/CoreGraphics.h>
@interface MessageView()
@property (nonatomic, weak) IBOutlet UILabel * lblMessage;
@property (nonatomic, weak)   IBOutlet NSLayoutConstraint * cnstrHeight;

@end

@implementation MessageView


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)onTap {
    [self hide];
}

- (void)updateWithMessage:(NSString *)aMessage {
    self.lblMessage.text = aMessage;
}

- (void)show {
    [self silentShow];
}

- (void)silentShow {
    self.cnstrHeight.constant = 20;
    [self layoutIfNeeded];
}

- (void)hide {
    [self silentHide];
    [self.delegate didHide];
}

- (void)silentHide {
    self.cnstrHeight.constant = 0;
    [self layoutIfNeeded];

}
@end
