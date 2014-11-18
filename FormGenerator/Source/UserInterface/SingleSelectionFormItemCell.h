//
//  SingleSelectionFormItemCell.h
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/13/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "AbstractFormItemCell.h"

@interface SingleSelectionFormItemCell : AbstractFormItemCell
@property (nonatomic, weak) IBOutlet UILabel * lblValue;
@end
