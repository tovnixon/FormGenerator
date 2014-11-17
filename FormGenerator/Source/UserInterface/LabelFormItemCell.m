//
//  LabelFormItemCell.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/12/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "LabelFormItemCell.h"
#import "FormItemProtocol.h"

@implementation LabelFormItemCell
@synthesize leftView;
@synthesize rightView;
#pragma mark - FormItemCell delegate
- (void)configureWithFormItem:(id<FormItemProtocol>)aFormItem {
    [super configureWithFormItem:aFormItem];
    self.lblValue.text = [aFormItem defaultValue];
}

- (NSDictionary *)keyedValue {
    return @{kValidationKeyKey :[self bindingKey], kValidationValueKey : self.lblValue.text};
}

- (CGSize)calculateSize:(CGSize)parentSize {
    CGSize result;
    float widthOfTitle = parentSize.width * .33;
    CGSize sizeOfTitle = [self.lblTitle.text boundingRectWithSize:CGSizeMake(widthOfTitle, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:22]}
                                                          context:nil].size;
    
    float widthOfDescription = parentSize.width;
    CGSize sizeOfDescription = [self.lblDescription.text boundingRectWithSize:CGSizeMake(widthOfDescription, CGFLOAT_MAX)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:17]}
                                                                      context:nil].size;
//    NSLog(@"Cell: %@, parentWidth: %5.2f, title = %@, description = %@", [self bindingKey], parentSize.width, NSStringFromCGSize(sizeOfTitle), NSStringFromCGSize(sizeOfDescription));
    NSLog(@"Cell(%@).origin: parentWidth %4.2f, title = %@, description = %@",[self bindingKey], parentSize.width, NSStringFromCGPoint(self.lblTitle.frame.origin), NSStringFromCGPoint(self.lblDescription.frame.origin));
    result = CGSizeMake(1, sizeOfTitle.height + sizeOfDescription.height + 28);
    return result;
}


@end
