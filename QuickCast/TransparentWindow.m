//
//  QuickCast
//
//  Copyright (c) 2013 Pete Nelson, Neil Kinnish, Dom Murphy
//

#import "TransparentWindow.h"

@implementation TransparentWindow{
    NSTextField *selectionDimensions;
}

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation
{
    
    self = [super
            initWithContentRect:contentRect
            styleMask:NSBorderlessWindowMask
            backing:bufferingType
            defer:deferCreation];
    if (self)
    {
        [self setOpaque:NO];
        NSColor *semiTransparentBlue =
        [NSColor colorWithDeviceRed:0.1 green:0.1 blue:0.1 alpha:0.6];
        [self setBackgroundColor:semiTransparentBlue];
        [self setContentBorderThickness:2 forEdge:NSMinYEdge];
        [self setIgnoresMouseEvents:NO];
        [self setLevel:NSScreenSaverWindowLevel + 1];
        
        [selectionDimensions setHidden:NO];
        
        /*
        CGWindowListOption listOptions = kCGWindowListExcludeDesktopElements;
        CFArrayRef windowList = CGWindowListCopyWindowInfo(listOptions, kCGNullWindowID);
        
        NSMutableArray * prunedWindowList = [NSMutableArray array];
        
        CFRelease(windowList);
         */
        
    }
    
    
    return self;
}

- (void)goingToRecord{
    
    [selectionDimensions setHidden:YES];
    [self setIgnoresMouseEvents:YES];
    
}

- (void)updateSelectionDimentions:(NSRect)dimensions{
    
    if(!selectionDimensions){
        selectionDimensions = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, 200, 20)];
        
        [selectionDimensions setBezeled:NO];
        [selectionDimensions setDrawsBackground:NO];
        [selectionDimensions setEditable:NO];
        [selectionDimensions setSelectable:NO];
        [selectionDimensions setFont:[NSFont fontWithName:@"HelveticaNeue" size:18]];
        [selectionDimensions setTextColor:[NSColor whiteColor]];
        [selectionDimensions setStringValue:@""];
        [self.contentView addSubview:selectionDimensions];
    }
    
    [selectionDimensions setHidden:NO];
    int roundedWidth = round(2.0f * dimensions.size.width) / 2.0f;
    int roundedHeight = round(2.0f * dimensions.size.height) / 2.0f;
    
    NSString *dime = [NSString stringWithFormat:@"Selection %d x %d", roundedWidth, roundedHeight];
    //NSLog(@"-----------%f",dimensions.size.width);
    [selectionDimensions setStringValue:dime];
}

@end
