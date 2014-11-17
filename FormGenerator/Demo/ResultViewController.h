//
//  ResultViewController.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/17/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController
@property (nonatomic) IBOutlet UITextView * tvXML;
- (void)setText:(NSString *)text;
@end
