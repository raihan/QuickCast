//
//  QuickCast
//
//  Copyright (c) 2013 Pete Nelson, Neil Kinnish, Dom Murphy
//

#import "Exporter.h"
#import "AppDelegate.h"
#import "AmazonS3Client.h"
#import "AmazonCredentials.h"
#import <AVFoundation/AVAssetExportSession.h>
#import "Uploader.h"
#import <ApplicationServices/ApplicationServices.h>
#import "TransparentWindow.h"
#import "VideoView.h"
#import "Utilities.h"
#import "FFMPEGEngine.h"

@implementation Exporter{
    
    NSString *filename;
    NSURL *tempUrl;
    NSURL *finishedUrl;
    AVAsset *videoAsset;
   
}

@synthesize uploader;

#pragma mark Capture


- (NSString *)saveThumbnail:(NSSize)newSize thumb:(NSImage *)thumb suffix:(NSString *)suffix{
    
    NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
    [smallImage lockFocus];
    [thumb setSize: newSize];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [thumb drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [smallImage unlockFocus];
    // Write to JPG
    NSData *imageData = [smallImage  TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
    NSString *filepath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"quickcast%@.jpg",suffix]];
    [imageData writeToFile:filepath atomically:NO];
    
    return filepath;
}

- (void)thumbnailAndUpload:(NSDictionary *)details length:(NSString *)length width:(NSString *)width height:(NSString *)height{
    
    NSImage *thumb = [Utilities thumbnailImageForVideo:finishedUrl atTime:(NSTimeInterval)0.5];
    
    [thumb setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![thumb isValid])
    {
        NSLog(@"Invalid Image");
    } else
    {
        NSSize newSize = [Utilities resize:thumb.size withMax:160];
        [self saveThumbnail:newSize thumb:thumb suffix:@"_thumb"];
    }
    
    // upload is async so can be done on the main thread
    dispatch_async(dispatch_get_main_queue(),^ {
        
        if(!self.uploader)
            self.uploader = [[Uploader alloc] init];
    
        [self.uploader performUpload:filename video:finishedUrl thumbnail:[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"quickcast_thumb.jpg"]] details:details length:length width:width height:height];
    });
}


- (void)startUpload:(NSDictionary *)details width:(NSString *)width height:(NSString *)height{
    
    //dispatch_async(dispatch_get_main_queue(),^ {
        
    NSDate *time = [NSDate date];
    NSDateFormatter* df = [NSDateFormatter new];
    [df setDateFormat:@"dd-MM-yyyy-hh-mm-ss"];
    NSString *timeString = [df stringFromDate:time];
    
    filename = [NSString stringWithFormat:@"quickcast-%@.%@", timeString, @"mp4"];

    AppDelegate *app = (AppDelegate *)[NSApp delegate];
    NSString *quickcast = app.applicationSupport.path;
    
    tempUrl = [NSURL fileURLWithPath:[quickcast stringByAppendingPathComponent:@"quickcast-compressed.mp4"]];
    
    videoAsset = [AVAsset assetWithURL:tempUrl];
    //CMTime totalTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(videoAsset.duration), videoAsset.duration.timescale);
    NSString *length = [NSString stringWithFormat:@"%f",CMTimeGetSeconds(videoAsset.duration)];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //NSString *quickcastPath = [prefs objectForKey:@"quickcastNewSavePath"];
    
    NSString *chosenPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Movies/QuickCast"];
    
    if([prefs objectForKey:@"quickcastSavePathBookmark"] != nil){
        
        NSData *bookmark = [prefs objectForKey:@"quickcastSavePathBookmark"];
        NSError* theError;
        NSURL* bookmarkURL = [NSURL URLByResolvingBookmarkData:bookmark
                                                       options:NSURLBookmarkResolutionWithSecurityScope
                                                 relativeToURL:nil
                                           bookmarkDataIsStale:nil
                                                         error:&theError];
        
        finishedUrl = [bookmarkURL URLByAppendingPathComponent:filename];//[NSURL fileURLWithPath:[quickcastPath stringByAppendingPathComponent:filename]];
        chosenPath = bookmarkURL.path;
    }
    else{
        
        finishedUrl = [NSURL fileURLWithPath:[chosenPath stringByAppendingPathComponent:filename]];
        
    }
    
    //if(quickcastPath.length > 0){
        
        
    //}
    if([prefs objectForKey:@"quickcastSavePathBookmark"] != nil)
        [finishedUrl startAccessingSecurityScopedResource];
    
    if(CMTimeGetSeconds(videoAsset.duration) < 10.0 && (width.intValue < 300 || height.intValue < 300)){
    
        NSString *input = [quickcast stringByAppendingPathComponent:@"quickcast.mov"];
        NSString *tempOutput = [quickcast stringByAppendingPathComponent:[NSString stringWithFormat:@"quickcast.%@", @"gif"]];
        NSString *output = [chosenPath stringByAppendingPathComponent:[NSString stringWithFormat:@"quickcast-%@.%@", timeString, @"gif"]];
        NSError *error;
        // Delete any existing movie file first
        if ([[NSFileManager defaultManager] fileExistsAtPath:output]){
            
            if (![[NSFileManager defaultManager] removeItemAtPath:output error:&error]){
                NSLog(@"Error deleting compressed gif %@",[error localizedDescription]);
            }
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:tempOutput]){
            
            if (![[NSFileManager defaultManager] removeItemAtPath:tempOutput error:&error]){
                NSLog(@"Error deleting compressed gif %@",[error localizedDescription]);
            }
        }
        
        FFMPEGEngine *engine = [[FFMPEGEngine alloc] init];
        [engine process:input output:tempOutput width:@"" height:@""];
        
        //then to looping gif
        [engine process:tempOutput output:output width:@"" height:@""];
        
        //remove temp gif
        if ([[NSFileManager defaultManager] fileExistsAtPath:tempOutput]){
            
            if (![[NSFileManager defaultManager] removeItemAtPath:tempOutput error:&error]){
                NSLog(@"Error deleting compressed gif %@",[error localizedDescription]);
            }
        }
        
    }
    
    if([prefs objectForKey:@"quickcastSavePathBookmark"] != nil)
        [finishedUrl stopAccessingSecurityScopedResource];
    
    
    
    
    NSError *error;
    //copy temp to finished
    [[NSFileManager defaultManager] copyItemAtURL:tempUrl toURL:finishedUrl error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    }
    
    [self thumbnailAndUpload:details length:length width:width height:height];
}


@end
