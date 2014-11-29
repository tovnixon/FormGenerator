//
//  MessageView.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/17/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "MessageView.h"
#import <CoreGraphics/CoreGraphics.h>
@interface MessageView() {
    BOOL _isPresented;
}

@property (nonatomic, weak) IBOutlet UILabel * lblMessage;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * cnstrHeight;

@end

@implementation MessageView


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _isPresented = YES;
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
    if (!_isPresented) {
        self.cnstrHeight.constant = 20;
        _isPresented = YES;
        [self.delegate didShow];
    }

}

- (void)silentShow {
    if (!_isPresented) {
        self.cnstrHeight.constant = 20;
//        [self layoutIfNeeded];
        _isPresented = YES;
//        [self.delegate didShow];
    }
}

- (void)hide {
    if (_isPresented) {
        self.cnstrHeight.constant = 0;
//        [self layoutIfNeeded];
        _isPresented = NO;
        [self.delegate didHide];
    }
}

- (void)silentHide {
    if (_isPresented) {
        self.cnstrHeight.constant = 0;
//        [self layoutIfNeeded];
        _isPresented = NO;
    }
}
@end
