//
//  LTChalkboardImageView.m
//  LecturesTest
//
//  Created by Martyn McWhirter on 19/10/2012.
//  Copyright (c) 2012 Martyn McWhirter. All rights reserved.
//

#import "LTChalkboardImageView.h"

@implementation LTChalkboardImageView

- (id)initWithFrame:(NSRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSRect rect = NSMakeRect(0, 0, 930, 680);
        chalkboardImageView = [[NSImageView alloc] initWithFrame:rect];
        [chalkboardImageView setImageScaling:NSScaleToFit];
        [chalkboardImageView setImage:[NSImage imageNamed:@"chalkboard.jpg"]];
        
        [self addSubview:chalkboardImageView];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect{

}

@end
