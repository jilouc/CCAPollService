//
//  CCAPollService.m
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

#import "CCAPollService.h"

@interface CCAPollService ()
{
    struct CCAPollServiceDelegateCache {
        unsigned int delegatePollServiceShouldRun:1;
        unsigned int delegatePollServiceRun:1;
    } _delegateFlags;
}

@property (nonatomic, weak) NSTimer *serviceTimer;

@end

@implementation CCAPollService

+ (instancetype)serviceWithPollInterval:(NSTimeInterval)pollInterval
{
    return [[self alloc] initWithPollInterval:pollInterval];
}

+ (instancetype)serviceWithPollInterval:(NSTimeInterval)pollInterval
                               delegate:(id<CCAPollServiceDelegate>)delegate
{
    return [[self alloc] initWithPollInterval:pollInterval delegate:delegate];
}

+ (instancetype)serviceWithPollInterval:(NSTimeInterval)pollInterval
                                  block:(void (^)(id service, NSError *error))block
{
    return [[self alloc] initWithPollInterval:pollInterval block:block];
}

- (instancetype)initWithPollInterval:(NSTimeInterval)pollInterval
{
    self = [self init];
    if (self) {
        _pollInterval = pollInterval;
        _shouldRunImmediately = YES;
        
        NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
        [dc addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (instancetype)initWithPollInterval:(NSTimeInterval)pollInterval
                            delegate:(id<CCAPollServiceDelegate>)delegate
{
    self = [self initWithPollInterval:pollInterval];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithPollInterval:(NSTimeInterval)pollInterval
                               block:(void (^)(id service, NSError *error))block
{
    self = [self initWithPollInterval:pollInterval];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void)dealloc
{
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setDelegate:(id<CCAPollServiceDelegate>)delegate
{
    if (delegate != _delegate) {
        _delegate = delegate;
        _delegateFlags.delegatePollServiceShouldRun = [delegate respondsToSelector:@selector(pollServiceShouldRun:)];
    }
}

- (void)appDidBecomeActive:(NSNotification *)note
{
    if (self.shouldFetchOnAppActive) {
        [self runIfNeeded];
    }
}

- (void)start
{
    if ([self.serviceTimer isValid]) {
        return;
    }
    
    NSTimer *timer __attribute__((objc_precise_lifetime)) = [NSTimer timerWithTimeInterval:_pollInterval
                                                                                    target:self
                                                                                  selector:@selector(serviceTimerFired:)
                                                                                  userInfo:nil
                                                                                   repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    if (self.timerShouldRunWhenUITracking) {
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    }
    self.serviceTimer = timer;
    
    if (self.shouldRunImmediately) {
        [self serviceTimerFired:self.serviceTimer];
    }
}

- (void)stop
{
    if ([self.serviceTimer isValid]) {
        [self.serviceTimer invalidate];
        self.serviceTimer = nil;
    }
}

- (void)serviceTimerFired:(NSTimer *)timer
{
    [self runIfNeeded];
}

- (BOOL)canRun
{
    if (_delegateFlags.delegatePollServiceShouldRun) {
        return [self.delegate pollServiceShouldRun:self];
    }
    return YES;
}

- (void)run
{
    if (_delegateFlags.delegatePollServiceRun) {
        [self.delegate pollServiceRun:self];
    } else if (self.block) {
        self.block(self, nil);
    }
}

- (void)runIfNeeded
{
    if ([self canRun]) {
        [self run];
    }
}


@end
