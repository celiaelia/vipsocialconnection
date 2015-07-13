//
//  VIPButton.m
//  SocialConnection
//
//  Created by Celia on 10/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "VIPButton.h"
#import "QuartzCore/QuartzCore.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@implementation VIPButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
        [self customLayout];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
        [self customLayout];
    
    return self;
}

- (void)customLayout
{
    self.backgroundColor = RGB(91, 78, 46);
    self.titleLabel.textColor = RGB(226, 228, 209);
    self.alpha = 0.9;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
