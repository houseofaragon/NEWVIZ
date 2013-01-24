//
//  CustomNavigationBar.m
//  HouseSalad
//
//  Created by Karen Aragon on 1/21/13.
//  Copyright (c) 2013 karen. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

-(void) drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed: @"navbar.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
