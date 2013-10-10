//
//  QuickCast
//
//  Copyright (c) 2013 Pete Nelson, Neil Kinnish, Dom Murphy
//

#import <Cocoa/Cocoa.h>
#import "ResizeHandle.h"

@interface TransparentWindow : NSWindow

- (void)updateSelectionDimentions:(NSRect)dimensions;
- (void)goingToRecord;
@end
