//
//  TextAreaFormItemCell.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "AbstractFormItemCell.h"

@interface TextAreaFormItemCell : AbstractFormItemCell <UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITextView * tvInput;
@end
