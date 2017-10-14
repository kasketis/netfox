//
//  NFXLoader.m
//  netfox
//
//  Copyright © 2017 kasketis. All rights reserved.
//

#import "NFXLoader.h"

#ifdef OSX
    #import <netfox_osx/netfox_osx-Swift.h>
#else
    #import <netfox_ios/netfox_ios-Swift.h>
#endif

@implementation NFXLoader

+ (void)load
{
    [NSURLSessionConfiguration performSelector:NSSelectorFromString(@"implementNetfox")];
}

@end
