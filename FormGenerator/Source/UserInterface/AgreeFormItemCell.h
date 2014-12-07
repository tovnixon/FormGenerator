//
//  AgreeFormItemCell.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/16/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "AbstractFormItemCell.h"

@interface AgreeFormItemCell : AbstractFormItemCell <UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UISwitch * switcher;
- (IBAction)switched:(id)sender;
@property CGFloat height;
@end
