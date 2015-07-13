//
//  VIPTextView.m
//  SocialConnection
//
//  Created by Celia on 14/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "VIPTextView.h"

@interface VIPTextView()
{
    UIColor *color;
}

@end

@implementation VIPTextView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
        [self customizeTextView];
    return self;
}

- (void)customizeTextView
{
    self.layer.cornerRadius = 10;
    color = [UIColor grayColor];
    self.tintColor = [UIColor lightGrayColor];
}

@end
