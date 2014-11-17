//
//  AbstractFormItemCell.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormItemCellProtocol.h"
#import "MessageView.h"

@interface AbstractFormItemCell : UITableViewCell <FormItemCellProtocol, MessageViewDelegate>

@property (nonatomic, strong) IBOutlet UIView * leftView;
@property (nonatomic, strong) IBOutlet UIView * rightView;
@property (nonatomic, strong) IBOutlet UILabel * lblTitle;
@property (nonatomic, strong) IBOutlet UILabel * lblDescription;

@property (nonatomic) MessageView * errorView;
@property (nonatomic, strong) UIButton * validationSign;
@property (nonatomic) NSString * currentErrorMessage;

@property (nonatomic, weak)   IBOutlet NSLayoutConstraint * cnstrcontent2Top;
@property (nonatomic, weak)   IBOutlet NSLayoutConstraint * cnstrTitle2Left;
@property (nonatomic, strong) IBOutlet UIButton * btnHelpInfo;
@property (nonatomic, weak)   IBOutlet NSLayoutConstraint * cnstrRightEnd2Right;
@property float leftConstraintValue;

- (IBAction)helpInfo:(id)sender;

@end

