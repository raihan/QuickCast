//
//  MaxLengthFormatter.m
//  QuickCast
//
//  Created by Pete Nelson on 06/08/2013.
//

#import "MaxLengthFormatter.h"

@implementation MaxLengthFormatter

- (id)init {
    
    if(self = [super init]){
        
        maxLength = INT_MAX;
    }
    
    return self;
}

- (void)setMaximumLength:(int)len {
    maxLength = len;
}

- (int)maximumLength {
    return maxLength;
}

- (NSString *)stringForObjectValue:(id)object {
    return (NSString *)object;
}

- (BOOL)getObjectValue:(id *)object forString:(NSString *)string errorDescription:(NSString **)error {
    *object = string;
    return YES;
}

- (BOOL)isPartialStringValid:(NSString **)partialStringPtr
       proposedSelectedRange:(NSRangePointer)proposedSelRangePtr
              originalString:(NSString *)origString
       originalSelectedRange:(NSRange)origSelRange
            errorDescription:(NSString **)error {
    if ([*partialStringPtr length] > maxLength) {
        return NO;
    }

    
    return YES;
}

- (NSAttributedString *)attributedStringForObjectValue:(id)anObject withDefaultAttributes:(NSDictionary *)attributes {
    return nil;
}

@end