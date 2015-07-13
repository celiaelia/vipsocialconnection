//
//  VIPTextField.m
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "VIPTextField.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@interface VIPTextField()
{
    NSInteger leftMargin;
    UIColor *color;
}

@end

@implementation VIPTextField

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
        [self customizeTextField];
    return self;
}

- (void)customizeTextField
{
    self.tintColor = [UIColor lightGrayColor];
    leftMargin = 10;
    if(self.tag < 100)
    {
        UIColor *pColor = [UIColor darkGrayColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: pColor}];
        self.layer.cornerRadius = 10;
    }
    else
        leftMargin = 30;
    
    color = [UIColor blackColor];
    CGRect frame = self.frame;
    frame.size.height = 38;
    self.frame = frame;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x += leftMargin;
    
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    bounds.origin.x += leftMargin;
    
    return bounds;
}

@end
