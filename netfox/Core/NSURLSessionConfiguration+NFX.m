//
//  NSURLSessionConfiguration+NFX.m
//  netfox_ios
//
//  Created by Alex Bofu on 23/07/2018.
//  Copyright © 2018 kasketis. All rights reserved.
//

#import "NSURLSessionConfiguration+NFX.h"
#import <netfox/netfox-Swift.h>

@implementation NSURLSessionConfiguration (NFX)

+ (void)load {
    [[NFX sharedInstance] start];
}

@end
