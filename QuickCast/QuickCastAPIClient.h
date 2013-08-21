
#import "QuickCastAPIClient.h"
#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPClient.h>

@interface QuickCastAPIClient : AFHTTPClient

+ (QuickCastAPIClient *)sharedClient;

@end