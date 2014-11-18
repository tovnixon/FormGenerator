//
//  TextFieldFormItemCell.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "AbstractFormItemCell.h"

@interface TextFieldFormItemCell : AbstractFormItemCell <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField * txtInput;
@end
