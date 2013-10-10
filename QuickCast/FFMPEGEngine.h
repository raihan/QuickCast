//
//  QuickCast
//
//  Copyright (c) 2013 Pete Nelson, Neil Kinnish, Dom Murphy
//

#import <Foundation/Foundation.h>

@interface FFMPEGEngine : NSObject

- (NSString *)process:(NSString *)inputPath output:(NSString *)outputPath width:(NSString *)width height:(NSString *)height;

@end
