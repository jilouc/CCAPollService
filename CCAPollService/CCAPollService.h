//
//  CCAPollService.h
//  CCAPollService
//
//  Created by Jean-Luc Dagon on 17/01/2014.
//
//  Copyright (c) 2014 Cocoapps.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Foundation/Foundation.h>

@class CCAPollService;

@protocol CCAPollServiceDelegate <NSObject>

@optional
- (BOOL)pollServiceShouldRun:(CCAPollService *)service;
- (void)pollServiceRun:(CCAPollService *)service;

@end

@interface CCAPollService : NSObject

+ (instancetype)serviceWithPollInterval:(NSTimeInterval)pollInterval;
+ (instancetype)serviceWithPollInterval:(NSTimeInterval)pollInterval delegate:(id<CCAPollServiceDelegate>)delegate;
+ (instancetype)serviceWithPollInterval:(NSTimeInterval)pollInterval block:(void(^)(id service, NSError *error))block;

@property (nonatomic, readonly) NSTimeInterval pollInterval;

@property (nonatomic, assign) BOOL shouldFetchOnAppActive; // default YES
#if TARGET_OS_IOS == 1
@property (nonatomic, assign) BOOL timerShouldRunWhenUITracking; // default NO
#endif
@property (nonatomic, assign) BOOL shouldRunImmediately; // default YES

@property (nonatomic, copy) void(^block)(id service, NSError *error);
@property (nonatomic, weak) id<CCAPollServiceDelegate> delegate;


- (void)start;
- (void)stop;

- (void)run;
- (BOOL)canRun;

@end
