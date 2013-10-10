//
//  QuickCast
//
//  Copyright (c) 2013 Pete Nelson, Neil Kinnish, Dom Murphy
//

#import <Cocoa/Cocoa.h>

@class ResizeHandle;

@protocol ResizeHandleDelegate<NSObject>
- (void)resizeCorner:(NSString *)corner toPoint:(NSPoint)newPoint offset:(NSPoint)offset;
- (void)selectRect;
@end

@interface ResizeHandle : NSBox{
    NSString *whichCorner;
}
@property NSString *whichCorner;
@property(readwrite, weak) id <ResizeHandleDelegate> delegate;


@end
