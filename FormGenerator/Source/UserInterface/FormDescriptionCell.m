//
//  FormDescriptionCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/16/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "FormDescriptionCell.h"
#import "FormItemProtocol.h"

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
    return CGSizeMake(1, 120);
}
//- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
//    CGRect frame = aWebView.frame;
//    frame.size.height = 1;
//    aWebView.frame = frame;
//    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
//    frame.size = fittingSize;
//    aWebView.frame = frame;
//    self.height = fittingSize.height + 10;
//    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
//}

@end
