//
//  LLLog.m
//
//  Created by Stephen Balaban on 5/15/13.
//
//  LLLog is Released under the New BSD License.
//  Contribute patches at: https://github.com/lambdal
//
//  Copyright (c) 2013, Lambda Labs, Inc.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of the Lambda Labs, Inc. nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL LAMBDA LABS, INC. BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

// Any time you start a new LLLog function, paste this into it:
#if LL_ENABLED_GA
#endif

#if LL_ENABLED_MIXPANEL
#endif

#if LL_ENABLED_FLURRY
#endif

#import "LLLog.h"

static LLLog *sharedLLLog;

@implementation LLLog

+ (void)initialize {
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        sharedLLLog = [[LLLog alloc] init];
    }
}

+ (LLLog *)sharedInstance {
    return sharedLLLog;
}

/**
 * Call this when you want to start logging. (Usually in applicationDidFinishLaunching:)
 */
+ (void)startLogging {
#if LL_ENABLED_GA
    // -- Google Analytics
    // Override point for customization after application launch.
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = NO;
    // Create tracker instance.
    [[GAI sharedInstance] trackerWithTrackingId:LL_TOKEN_GA];
    [GAI sharedInstance].debug = NO;
#endif
    
#if LL_ENABLED_MIXPANEL
    Mixpanel *mixpanel = [Mixpanel sharedInstanceWithToken:LL_TOKEN_MIXPANEL];
    [mixpanel identify:mixpanel.distinctId];
#endif
    
#if LL_ENABLED_FLURRY
    [Flurry startSession:LL_TOKEN_FLURRY];
#endif
    
}

+ (void)logKey:(NSString *)key withProperties:(id)properties {
#if LL_ENABLED_GA
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Event"
                                                      withAction:key
                                                       withLabel:[NSString stringWithFormat:@"%@", properties]
                                                       withValue:nil];
#endif
    
#if LL_ENABLED_MIXPANEL
    if ([[properties class] isSubclassOfClass:[NSDictionary class]])
        [[Mixpanel sharedInstance] track:key properties:properties];
    else if (properties == nil)
        [[Mixpanel sharedInstance] track:key];
    else
        [[Mixpanel sharedInstance] track:key
                              properties:@{ @"properties": [NSString stringWithFormat:@"%@", properties] }];
    
#endif
    
#if LL_ENABLED_FLURRY
    if ([[properties class] isSubclassOfClass:[NSDictionary class]])
        [Flurry logEvent:key withParameters:properties];
    else if (properties == nil)
        [Flurry logEvent:key];
    else
        [Flurry logEvent:key withParameters:@{ @"properties": [NSString stringWithFormat:@"%@", properties] }];
#endif
    
}

+ (void)logErrorName:(NSString *)errorName withNSExceptionOrNSError:(id)error {
#if LL_ENABLED_GA
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Error"
                                                      withAction:error
                                                       withLabel:[NSString stringWithFormat:@"%@", error]
                                                       withValue:nil];
#endif
    
#if LL_ENABLED_MIXPANEL
    [[Mixpanel sharedInstance] track:errorName
                          properties:@{ @"ErrorDescription": [NSString stringWithFormat:@"%@", error] } ];
#endif
    
#if LL_ENABLED_FLURRY
    if ([error isKindOfClass:[NSError class]])
        [Flurry logError:errorName message:[NSString stringWithFormat:@"%@", error]
                   error:error];
    else if ([error isKindOfClass:[NSException class]])
        [Flurry logError:errorName message:[NSString stringWithFormat:@"%@", error]
               exception:error];
    else
        [Flurry logError:errorName
                 message:[NSString stringWithFormat:@"%@", error]
                   error:nil];
#endif
}

+ (void)logUserKey:(NSString *)key incrementBy:(float)amount {
#if LL_ENABLED_MIXPANEL
    [[Mixpanel sharedInstance].people increment:key by:@(amount)];
#endif
}

@end
