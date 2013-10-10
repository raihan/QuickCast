//
//  QuickCast
//
//  Copyright (c) 2013 Pete Nelson, Neil Kinnish, Dom Murphy
//

#import "VideoView.h"
#import "ResizeHandle.h"
#import "TransparentWindow.h"
#import "AppDelegate.h"

@implementation VideoView{
    
    ResizeHandle *handleTopLeft;
    ResizeHandle *handleTopRight;
    ResizeHandle *handleBottomLeft;
    ResizeHandle *handleBottomRight;
    
    ResizeHandle *handleCentre;
    
}

- (void)hideHandles{
    
    [handleTopLeft setHidden:YES];
    [handleTopRight setHidden:YES];
    [handleBottomLeft setHidden:YES];
    [handleBottomRight setHidden:YES];
    
    [handleCentre setHidden:YES];
}

- (void)setupHandles{

    handleTopLeft = [[ResizeHandle alloc] initWithFrame:NSMakeRect(0, self.frame.size.height-20,20,20)];

    [handleTopLeft setAcceptsTouchEvents:YES];
    [self addSubview:handleTopLeft];
    
    handleTopLeft.whichCorner = @"topleft";
    [handleTopLeft setDelegate:self];
    
     handleTopRight = [[ResizeHandle alloc] initWithFrame:NSMakeRect( self.frame.size.width -20, self.frame.size.height-20, 20, 20)];
     [handleTopRight setAcceptsTouchEvents:YES];
     handleTopRight.whichCorner = @"topright";
     [self addSubview:handleTopRight];
     [handleTopRight setDelegate:self];
     
    handleBottomLeft = [[ResizeHandle alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
    [handleBottomLeft setAcceptsTouchEvents:YES];
    handleBottomLeft.whichCorner = @"bottomleft";
    [self addSubview:handleBottomLeft];
    [handleBottomLeft setDelegate:self];
    
     handleBottomRight = [[ResizeHandle alloc] initWithFrame:NSMakeRect(self.frame.size.width -20, 0, 20, 20)];
     [handleBottomRight setAcceptsTouchEvents:YES];
     handleBottomRight.whichCorner = @"bottomright";
     [self addSubview:handleBottomRight];
     [handleBottomRight setDelegate:self];
    
    handleCentre = [[ResizeHandle alloc] initWithFrame:NSMakeRect((self.frame.size.width/2)-10, (self.frame.size.height/2)-10,20,20)];
    
    [handleCentre setAcceptsTouchEvents:YES];
    [self addSubview:handleCentre];
    
    handleCentre.whichCorner = @"centre";
    [handleCentre setDelegate:self];
    
    [handleTopLeft setHidden:NO];
    [handleTopRight setHidden:NO];
    [handleBottomLeft setHidden:NO];
    [handleBottomRight setHidden:NO];
    
    [handleCentre setHidden:NO];
}

- (id)initWithFrame:(NSRect)frame
{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    
    return self;
}

-(void)drawRect:(NSRect)dirtyRect
{
    [[NSColor clearColor] set];  // Using the default window colour,
    NSRectFill(dirtyRect);      // Only draw the part you need.
}

- (void)selectRect{
    
    //if is below min size just resize upwards
    if(self.frame.size.height < 50){
        NSRect mainFrame = self.frame;
        mainFrame.size.height = 50;
        [self setFrame:mainFrame];
        [self resetAllHandles];
        [self setNeedsDisplay:YES];
    }
    if(self.frame.size.width < 50){
        NSRect mainFrame = self.frame;
        mainFrame.size.width = 50;
        [self setFrame:mainFrame];
        [self resetAllHandles];
        [self setNeedsDisplay:YES];
    }
    AppDelegate *app = (AppDelegate *)[NSApp delegate];
    [app setSelection:self selected:self.frame];
    

}

- (void)resetAllHandles{
    
    NSRect topLeft = handleTopLeft.frame;
    topLeft.origin.x = 0;
    topLeft.origin.y = self.frame.size.height-20;
    [handleTopLeft setFrame:topLeft];
    
    NSRect topRight = handleTopRight.frame;
    topRight.origin.x = self.frame.size.width -20;
    topRight.origin.y = self.frame.size.height-20;
    [handleTopRight setFrame:topRight];
    
    NSRect bottomLeft = handleBottomLeft.frame;
    bottomLeft.origin.x = 0;
    bottomLeft.origin.y = 0;
    [handleBottomLeft setFrame:bottomLeft];
    
    NSRect bottomRight = handleBottomRight.frame;
    bottomRight.origin.x = self.frame.size.width -20;
    bottomRight.origin.y = 0;
    [handleBottomRight setFrame:bottomRight];
    
    NSRect centre = handleCentre.frame;
    centre.origin.x = self.frame.size.width/2 -10;
    centre.origin.y = self.frame.size.height/2 -10;
    [handleCentre setFrame:centre];


}

- (void)resizeCorner:(NSString *)corner toPoint:(NSPoint)newPoint offset:(NSPoint)offset{
    
    //needs to be refactored - auto layout would simplify however was just not working properly
       
    [(TransparentWindow *)self.window updateSelectionDimentions:self.frame];
    
    if([corner isEqualToString:@"topleft"]){
        
        
        NSRect handleTopLeftFrame = handleTopLeft.frame;
        //get the offset as we are clikcing in the middle of the handle
        handleTopLeftFrame.origin.x = newPoint.x - offset.x;
        handleTopLeftFrame.origin.y = newPoint.y  - offset.y;
        
        NSRect transparentFrame = self.frame;
        
        float diffx = transparentFrame.origin.x - handleTopLeftFrame.origin.x;
       
        transparentFrame.origin.x = handleTopLeftFrame.origin.x;
        transparentFrame.size.height = handleTopLeftFrame.origin.y - transparentFrame.origin.y + 20;
        
        transparentFrame.size.width += diffx;
        
        handleTopLeftFrame.origin.y = transparentFrame.size.height - 20;
        handleTopLeftFrame.origin.x = 0;
        [handleTopLeft setFrame:handleTopLeftFrame];
        
        NSRect topRight = handleTopRight.frame;
        topRight.origin.x = self.frame.size.width -20;
        topRight.origin.y = self.frame.size.height-20;
        [handleTopRight setFrame:topRight];
        
        NSRect bottomLeft = handleBottomLeft.frame;
        bottomLeft.origin.x = 0;
        bottomLeft.origin.y = 0;
        [handleBottomLeft setFrame:bottomLeft];
        
        NSRect bottomRight = handleBottomRight.frame;
        bottomRight.origin.x = self.frame.size.width -20;
        bottomRight.origin.y = 0;
        [handleBottomRight setFrame:bottomRight];
        
        NSRect centre = handleCentre.frame;
        centre.origin.x = self.frame.size.width/2 -10;
        centre.origin.y = self.frame.size.height/2 -10;
        [handleCentre setFrame:centre];
        
        [self setFrame:transparentFrame];
        
        
    }
    else if([corner isEqualToString:@"topright"]){
        
        NSRect handleTopRightFrame = handleTopRight.frame;
        //get the offset as we are clikcing in the middle of the handle
        handleTopRightFrame.origin.x = newPoint.x - offset.x;
        handleTopRightFrame.origin.y = newPoint.y  - offset.y;
        
        NSRect transparentFrame = self.frame;
        
        transparentFrame.size.width = handleTopRightFrame.origin.x - transparentFrame.origin.x + 20;
        transparentFrame.size.height = handleTopRightFrame.origin.y - transparentFrame.origin.y + 20;
        
        handleTopRightFrame.origin.y = transparentFrame.size.height - 20;
        handleTopRightFrame.origin.x = transparentFrame.size.width - 20;
        [handleTopRight setFrame:handleTopRightFrame];

        
        NSRect topLeft = handleTopLeft.frame;
        topLeft.origin.x = 0;
        topLeft.origin.y = self.frame.size.height-20;
        [handleTopLeft setFrame:topLeft];
        
        NSRect bottomLeft = handleBottomLeft.frame;
        bottomLeft.origin.x = 0;
        bottomLeft.origin.y = 0;
        [handleBottomLeft setFrame:bottomLeft];
        
        NSRect bottomRight = handleBottomRight.frame;
        bottomRight.origin.x = self.frame.size.width -20;
        bottomRight.origin.y = 0;
        [handleBottomRight setFrame:bottomRight];
        
        NSRect centre = handleCentre.frame;
        centre.origin.x = self.frame.size.width/2 -10;
        centre.origin.y = self.frame.size.height/2 -10;
        [handleCentre setFrame:centre];
        
        [self setFrame:transparentFrame];
        
    }
    else if([corner isEqualToString:@"bottomleft"]){
        
        NSRect handleBottomLeftFrame = handleBottomLeft.frame;
        //get the offset as we are clikcing in the middle of the handle
        handleBottomLeftFrame.origin.x = newPoint.x - offset.x;
        handleBottomLeftFrame.origin.y = newPoint.y  - offset.y;
        
        NSRect transparentFrame = self.frame;
        
        float diffx = transparentFrame.origin.x - handleBottomLeftFrame.origin.x;
        float diffy = transparentFrame.origin.y - handleBottomLeftFrame.origin.y;
        transparentFrame.origin.x = handleBottomLeftFrame.origin.x;
        transparentFrame.origin.y = handleBottomLeftFrame.origin.y;
        
        transparentFrame.size.width += diffx;
        transparentFrame.size.height += diffy;
        
        NSRect topLeft = handleTopLeft.frame;
        topLeft.origin.x = 0;
        topLeft.origin.y = self.frame.size.height-20;
        [handleTopLeft setFrame:topLeft];
        
        NSRect topRight = handleTopRight.frame;
        topRight.origin.x = self.frame.size.width -20;
        topRight.origin.y = self.frame.size.height-20;
        [handleTopRight setFrame:topRight];
        
        NSRect bottomRight = handleBottomRight.frame;
        bottomRight.origin.x = self.frame.size.width -20;
        bottomRight.origin.y = 0;
        [handleBottomRight setFrame:bottomRight];
        
        NSRect centre = handleCentre.frame;
        centre.origin.x = self.frame.size.width/2 -10;
        centre.origin.y = self.frame.size.height/2 -10;
        [handleCentre setFrame:centre];
        
        [self setFrame:transparentFrame];
        
    }
    else if([corner isEqualToString:@"bottomright"]){
        
        NSRect handleBottomRightFrame = handleBottomRight.frame;
        //get the offset as we are clikcing in the middle of the handle
        handleBottomRightFrame.origin.x = newPoint.x - offset.x;
        handleBottomRightFrame.origin.y = newPoint.y - offset.y;
        
        NSRect transparentFrame = self.frame;
        
        float diffy = transparentFrame.origin.y - handleBottomRightFrame.origin.y;
        
        transparentFrame.size.width = handleBottomRightFrame.origin.x - transparentFrame.origin.x + 20;
        transparentFrame.origin.y = handleBottomRightFrame.origin.y;
        
        transparentFrame.size.height += diffy;
        
        handleBottomRightFrame.origin.y = 0;
        handleBottomRightFrame.origin.x = transparentFrame.size.width - 20;
        [handleBottomRight setFrame:handleBottomRightFrame];
        
        NSRect topLeft = handleTopLeft.frame;
        topLeft.origin.x = 0;
        topLeft.origin.y = self.frame.size.height-20;
        [handleTopLeft setFrame:topLeft];
        
        NSRect topRight = handleTopRight.frame;
        topRight.origin.x = self.frame.size.width -20;
        topRight.origin.y = self.frame.size.height-20;
        [handleTopRight setFrame:topRight];
        
        NSRect bottomLeft = handleBottomLeft.frame;
        bottomLeft.origin.x = 0;
        bottomLeft.origin.y = 0;
        [handleBottomLeft setFrame:bottomLeft];
        
        NSRect centre = handleCentre.frame;
        centre.origin.x = self.frame.size.width/2 -10;
        centre.origin.y = self.frame.size.height/2 -10;
        [handleCentre setFrame:centre];
        
        [self setFrame:transparentFrame];
        
    }
    else if([corner isEqualToString:@"centre"]){
        
        NSRect handleCentreFrame = handleCentre.frame;
        //get the offset as we are clikcing in the middle of the handle
        handleCentreFrame.origin.x = newPoint.x - offset.x;
        handleCentreFrame.origin.y = newPoint.y  - offset.y;
        
        NSRect transparentFrame = self.frame;
        
        transparentFrame.origin.x = handleCentreFrame.origin.x - (transparentFrame.size.width/2)+10;
        transparentFrame.origin.y = handleCentreFrame.origin.y - (transparentFrame.size.height/2)+10;
        
        [self setFrame:transparentFrame];
        
    }
    
    [self setNeedsDisplay:YES];

}

@end
