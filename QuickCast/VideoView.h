//
//  QuickCast
//
//  Copyright (c) 2013 Pete Nelson, Neil Kinnish, Dom Murphy
//

#import <Cocoa/Cocoa.h>
#import "ResizeHandle.h"

@interface VideoView : NSView <ResizeHandleDelegate>

- (void)setupHandles;
- (void)hideHandles;

@end
