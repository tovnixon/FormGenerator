//
//  AgreeFormItemCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/16/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "AgreeFormItemCell.h"
#import "FormItemProtocol.h"

@interface AgreeFormItemCell() {
    BOOL _singleLoad;
}
@end

@implementation AgreeFormItemCell
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem showInfo:(BOOL)shouldShow delegate:(id<FormItemCellDelegate>)aDelegate {
    
    self.bindingKey = [aFormItem bindingKey];
    self.dataSourceKey = [aFormItem key];
    NSString *scriptionHTML = [NSString stringWithFormat:@"<html> \n"
                     "<head> \n"
                     "<style type=\"text/css\"> \n"
                     "body {font-family: \"%@\"; font-size: %@;}\n"
                     "</style> \n"
                     "</head> \n"
                     "<body>%@<br><br></body> \n"
                     "</html>", @"HelveticaNeue-Light", [NSNumber numberWithInt:22], aFormItem.label];
    [self.webView loadHTMLString:scriptionHTML baseURL:nil];
    self.webView.scrollView.scrollEnabled = NO;
}

- (IBAction)switched:(id)sender {
    [self.delegate cellValueChanged:self validationRequired:YES];
}

- (NSDictionary *)keyedValue {
    NSString * value = [self.switcher isOn] ? @"true" : @"false";
    return @{kValidationKeyKey : [self bindingKey], kValidationValueKey : value};
}

- (BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (CGSize)calculateSize:(CGSize)parentSize {
    return CGSizeMake(1, _singleLoad ? self.height : 120);
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    _singleLoad = YES;
    self.height = self.webView.scrollView.contentSize.height;
}

@end
