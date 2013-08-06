//
//  QuickCast
//
//  Copyright (c) 2013 Pete Nelson, Neil Kinnish, Dom Murphy
//

#import <Cocoa/Cocoa.h>
#import "MaxLengthFormatter.h"

@interface SignInWindowController : NSWindowController{
    BOOL uploading;
}
@property BOOL uploading;
@property (strong) IBOutlet NSTextField *validationLabel;
@property (strong) IBOutlet NSBox *statusBlock;
@property (strong) IBOutlet NSTextField *username;
@property (strong) IBOutlet NSSecureTextField *password;
@property (strong) IBOutlet NSImageView *messageImageView;
@property (strong) IBOutlet NSTextField *message;
- (IBAction)signUpClick:(id)sender;
- (IBAction)signInClick:(id)sender;
@property (strong) IBOutlet MaxLengthFormatter *usernameFormatter;
@property (strong) IBOutlet MaxLengthFormatter *passwordFormatter;

@end
