//
//  FormDescriptionCell.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/16/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "AbstractFormItemCell.h"

@interface FormDescriptionCell : AbstractFormItemCell <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView * webView;
@property CGFloat height;
@end
