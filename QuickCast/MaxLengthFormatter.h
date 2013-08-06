//
//  MaxLengthFormatter.h
//  QuickCast
//
//  Created by Pete Nelson on 06/08/2013.
//

#import <Foundation/Foundation.h>

@interface MaxLengthFormatter : NSFormatter {
    
    int maxLength;
    
}

- (void)setMaximumLength:(int)len;

- (int)maximumLength;

@end