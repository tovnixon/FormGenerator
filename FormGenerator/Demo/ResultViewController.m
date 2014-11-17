//
//  ResultViewController.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/17/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "ResultViewController.h"
@interface ResultViewController()
@property (nonatomic) NSString *txt;
@end

@implementation ResultViewController

- (void)setText:(NSString *)text {
    self.txt = text;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tvXML.text = self.txt;
}
@end
