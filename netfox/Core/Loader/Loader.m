//
//  Loader.m
//  netfox
//
//  Created by Nathan Jangula on 10/13/17.
//  Copyright © 2017 kasketis. All rights reserved.
//

#import "Loader.h"

#ifdef OSX
    #import <netfox_osx/netfox_osx-Swift.h>
#else
    #import <netfox_ios/netfox_ios-Swift.h>
#endif

@implementation Loader

+ (void)load
{
    [NSURLSessionConfiguration performSelector:NSSelectorFromString(@"implementNetfox")];
}

@end
