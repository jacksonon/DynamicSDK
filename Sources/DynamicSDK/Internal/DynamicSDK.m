#import "DynamicSDK.h"

double DynamicSDKVersionNumber = 1.0;
const unsigned char DynamicSDKVersionString[] = "1.0.0";

NSString * const DYKDynamicSDKName = @"DynamicSDK";

NSString * DYKDynamicSDKVersion(void) {
    return [NSString stringWithUTF8String:(const char *)DynamicSDKVersionString];
}
