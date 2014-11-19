//
//  FormDescriptionCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/16/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "FormDescriptionCell.h"
#import "FormItemProtocol.h"
@interface FormDescriptionCell() {
    BOOL _singleLoad;
}

@end
@implementation FormDescriptionCell
#pragma mark - FormItemCell delegate
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem showInfo:(BOOL)shouldShow delegate:(id<FormItemCellDelegate>)aDelegate {
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
