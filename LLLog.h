//
//  LLLog.h
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
//
//  LambdaLabsLambdaLabsLamb
//  a                      d
//  m                      a
//  b        \\            L
//  d         \\           a
//  a          \\          b
//  L         //\\         s
//  a        //  \\        L
//  b       //    \\       a
//  s                      m
//  L                      b
//  ambdaLabsLambdaLabsLambd
//
//  Usage:
//  1) Toggle from 0 -> 1 to enable an analytics platform.
//  2) #define LL_YOUR_<PLATFORM>_TOKEN in LLTokens.h where <PLATFORM> in { GA, MIXPANEL, FLURRY }
//  3) Done!
//
//  Optional:
//  4) Use the logKey:withProperties, logUserKey:incrementBy:, and logError:withProperties to log
//     events in your app!
//


#import <Foundation/Foundation.h>
#include "LLTokens.h"

// Token Check:
#ifdef LL_YOUR_GA_TOKEN
    #import "GAI.h"
    #define LL_ENABLED_GA 1
    #define LL_TOKEN_GA LL_YOUR_GA_TOKEN
#else
    #define LL_ENABLED_GA 0
#endif

#ifdef LL_YOUR_MIXPANEL_TOKEN
    #import "Mixpanel.h"
    #define LL_ENABLED_MIXPANEL 1
    #define LL_TOKEN_MIXPANEL LL_YOUR_GA_TOKEN
#else
    #define LL_ENABLED_MIXPANEL 0
#endif

#ifdef LL_YOUR_FLURRY_TOKEN
    #import "Flurry.h"
    #define LL_ENABLED_FLURRY 1
    #define LL_TOKEN_FLURRY LL_YOUR_FLURRY_TOKEN
#else
    #define LL_ENABLED_FLURRY 0
#endif

@interface LLLog : NSObject

+ (LLLog *)sharedInstance;

// Place this inside your app delegate's application:didFinishLaunchingWithOptions: method.
// E.g.
//
//     [LLLog startLogging];
//
+ (void)startLogging;

// Call this when you want to log an event (properties are optional but usually in the form of an NSDictionary).
// E.g., User registration:
//
//     [LLLog logKey:@"NewUser" properties:@{ @"Age": @"20-30", @"Gender": @"Male" }];
//
+ (void)logKey:(NSString *)key withProperties:(id)properties;

// Call this when you want to statefully log based on a unique key tied to the current user.
// E.g. Increment number of messages sent by this user by amount 1.
//
//     [LLLog logUserKey:@"messagesSent" incrementBy:1];
//
+ (void)logUserKey:(NSString *)userKey incrementBy:(float)amount;

// Call this when you have an NSError, NSException, or just something nasty to log.
// E.g.
//
//     [LLLog logError:@"InvalidEmail" withError:@{ @"InvalidEmailValue": @"foobar@baqux" }];
//     [LLLog logError:@"UIApplicationWillChangeStatusBarOrientationNotificationError" withError:error];
//     [LLLog logError:@"NSAccessibilityLayoutPointForScreenPointParameterizedAttributeException" withError:exception];
//
+ (void)logErrorName:(NSString *)errorName withNSExceptionOrNSError:(id)error;

    
@end
