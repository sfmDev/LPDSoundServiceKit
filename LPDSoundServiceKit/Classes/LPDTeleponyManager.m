//
//  LPDTeleponyManager.m
//  LPDSoundService
//
//  Created by PixelShi on 2017/9/13.
//  Copyright © 2017年 me.ele. All rights reserved.
//

#import "LPDTeleponyManager.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <CallKit/CXCallObserver.h>

#define CurrentSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IS_OS_10_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

@interface LPDTeleponyManager()

@property(nonatomic, strong) dispatch_source_t scanTimer;
@property (nonatomic, strong) CXCallObserver *cXCallObserver;
@property (nonatomic, strong) CTCallCenter *callCenter;

@end

@implementation LPDTeleponyManager

+ (instancetype)sharedInstance {
    static LPDTeleponyManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LPDTeleponyManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.teleponyStateSignal = [RACReplaySubject replaySubjectWithCapacity: 1];
        if (CurrentSystemVersion > 10.0) {
            _cXCallObserver = [[CXCallObserver alloc] init];
        } else {
            _callCenter = [[CTCallCenter alloc] init];
        }
    }
    return self;
}

- (BOOL)isConnected {
    if (CurrentSystemVersion >= 10.0) {
        if (self.cXCallObserver.calls.count == 0) {
            return NO;
        } else {
            [self setTimeout];
            return YES;
        }
    } else {
        if (self.callCenter.currentCalls.count == 0) {
            return NO;
        } else {
            [self setTimeout];
            return YES;
        }
    }
}

- (void)setTimeout {
    dispatch_queue_t quene = dispatch_get_main_queue();
    self.scanTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(self.scanTimer, DISPATCH_TIME_NOW, 0, 0);
    dispatch_source_set_event_handler(self.scanTimer, ^{
        [self createStateSignal];
    });
    dispatch_resume(self.scanTimer);
}

- (void)createStateSignal {
    if ([self isConnected]) {
        //        [(RACSubject *)self.teleponyStateSignal sendNext: @"Connected"];
    } else {
        dispatch_source_cancel(self.scanTimer);
        [(RACSubject *)self.teleponyStateSignal sendCompleted];
    }
}

@end

