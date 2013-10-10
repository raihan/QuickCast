//
//  QuickCast
//
//  Copyright (c) 2013 Pete Nelson, Neil Kinnish, Dom Murphy
//
#import "ResizeHandle.h"

@implementation ResizeHandle{

    NSPoint _mouseDownPoint;
    NSRect currentRect;
    NSPoint offset;
}

@synthesize whichCorner;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // [super setBorderColor:[NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
        [super setFillColor:[NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:0.5]];
        [super setBorderType:NSNoBorder];
        [super setBoxType:NSBoxCustom];
        currentRect = frame;
    }
    
    return self;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
	return YES;
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}


- (void)mouseDown:(NSEvent *)theEvent
{
	_mouseDownPoint = [theEvent locationInWindow];
    NSRect frameRelativeToScreen = [self convertRect:self.bounds toView:nil];
    float xoffset = _mouseDownPoint.x - frameRelativeToScreen.origin.x;
    float yoffset = _mouseDownPoint.y - frameRelativeToScreen.origin.y;
    
    offset = NSMakePoint(xoffset, yoffset);
    [[NSCursor closedHandCursor] set];
    //NSLog(@"%f %f ",frameRelativeToScreen.origin.x,frameRelativeToScreen.origin.y);
    
}

- (void)mouseEntered:(NSEvent *)theEvent{
    [[NSCursor openHandCursor] set];
}

- (void)mouseExited:(NSEvent *)theEvent{
    [[NSCursor arrowCursor] set];
}

- (void)mouseUp:(NSEvent *)theEvent
{
	//called here has well to ensure handles are in exactly the right place when letting go
    if(![whichCorner isEqualToString:@"centre"])
        [self  setHandlePositioning:theEvent];
	[self.delegate selectRect];
    [[NSCursor arrowCursor] set];
    
}

- (void)setHandlePositioning:(NSEvent *)theEvent{
    
    NSPoint curPoint = [theEvent locationInWindow];
    NSRect newRect = self.frame;
    newRect.origin.x = curPoint.x;
    newRect.origin.y = curPoint.y;
    
    [self.delegate resizeCorner:whichCorner toPoint:curPoint offset:offset];

}

- (void)mouseDragged:(NSEvent *)theEvent
{
	[self  setHandlePositioning:theEvent];
    //NSLog(@"new paoing %f %f %f %f",newRect.origin.x,newRect.origin.y,curPoint.x,curPoint.y);
	//NSRect previousSelectionRect = currentRect;
	//_selectionRect = NSMakeRect(
                               // MIN(_mouseDownPoint.x, curPoint.x),
                                //MIN(_mouseDownPoint.y, curPoint.y),
                                //MAX(_mouseDownPoint.x, curPoint.x) - MIN(_mouseDownPoint.x, curPoint.x),
                                //MAX(_mouseDownPoint.y, curPoint.y) - MIN(_mouseDownPoint.y, curPoint.y));
    
    //int roundedWidth = round(2.0f * _selectionRect.size.width) / 2.0f;
    //int roundedHeight = round(2.0f * _selectionRect.size.height) / 2.0f;
    
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

@end
