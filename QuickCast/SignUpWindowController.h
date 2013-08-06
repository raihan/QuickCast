//
//  QuickCast
//
//  Copyright (c) 2013 Pete Nelson, Neil Kinnish, Dom Murphy
//

#import <Cocoa/Cocoa.h>
#import "MaxLengthFormatter.h"

@interface SignUpWindowController : NSWindowController{
    BOOL uploading;
}
@property BOOL uploading;
@property (strong) IBOutlet NSTextField *validationLabel;
@property (strong) IBOutlet NSTextField *email;
@property (strong) IBOutlet NSBox *statusBlock;
@property (strong) IBOutlet NSTextField *firstName;
@property (strong) IBOutlet NSTextField *lastName;
@property (strong) IBOutlet NSTextField *username;
@property (strong) IBOutlet NSSecureTextField *password;
@property (strong) IBOutlet NSButton *mailingList;
@property (strong) IBOutlet NSTextField *message;
@property (strong) IBOutlet NSImageView *validationImageView;
- (IBAction)signInClick:(id)sender;
- (IBAction)signUpClick:(id)sender;
@property (strong) IBOutlet NSButton *signupButton;
@property (strong) IBOutlet MaxLengthFormatter *usernameFormatter;
@property (strong) IBOutlet MaxLengthFormatter *nameFormatter;
@property (strong) IBOutlet MaxLengthFormatter *emailFormatter;
@property (strong) IBOutlet MaxLengthFormatter *passwordFormatter;

@end
