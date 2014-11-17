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
@property (nonatomic) UILabel * lblMessage;
@end
@implementation MessageView
- (id)initWithMessage:(NSString *)aMessage {
    CGSize size = [aMessage boundingRectWithSize:CGSizeMake(250, CGFLOAT_MAX)
                                          options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}
                                                    context:nil].size;
    CGRect frame = CGRectMake(0, 0, ceilf(size.width) + 8, ceilf(size.height) + 4);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.lblMessage = [[UILabel alloc] initWithFrame:frame];
        _lblMessage.backgroundColor = [UIColor clearColor];
        _lblMessage.text = aMessage;
        _lblMessage.font = [UIFont systemFontOfSize:14];
        _lblMessage.textColor = [UIColor redColor];
        _lblMessage.textAlignment = NSTextAlignmentCenter;
        _lblMessage.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        [self addSubview:_lblMessage];
        
        self.layer.cornerRadius = 4;
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideError)];
        [self addGestureRecognizer:gestureRecognizer];
        
    } return self;

}

- (id)initWithFrame:(CGRect)frame message:(NSString *)aMessage {
    self = [super initWithFrame:frame];
    if (self) {
        self.lblMessage = [[UILabel alloc] initWithFrame:frame];
        _lblMessage.backgroundColor = [UIColor clearColor];
        _lblMessage.text = aMessage;
        _lblMessage.textColor = [UIColor redColor];
        [self addSubview:_lblMessage];

        self.layer.cornerRadius = 4;
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideError)];
        [self addGestureRecognizer:gestureRecognizer];

    } return self;
}

- (void)updateWithMessage:(NSString *)aMessage {
    self.lblMessage.text = aMessage;
}

- (void)hideAnimated:(BOOL)animated completion:(HidingCompletionBlock)block {
    if (animated) {
        [UIView animateWithDuration:.1f animations:^{
            self.alpha = .0f;
        } completion:^(BOOL finished) {
//            block();
            [self.delegate didHide];
            [self hide];
        
        }];
    } else {
//        block();
        [self.delegate didHide];
        [self hide];
    }
}

- (void)hideAnimated:(BOOL)animated {
    [self hideAnimated:animated completion:nil];
}

- (void)hideError {
    [self hideAnimated:YES];
}

- (void)hide {
    
    [self removeFromSuperview];
    self.alpha = 1.0f;
}
@end
