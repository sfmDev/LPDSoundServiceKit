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
#import <CallKit/CXCall.h>

#define CurrentSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface LPDTeleponyManager() <CXCallObserverDelegate>

@property (nonatomic, strong) CXCallObserver *cXCallObserver;
@property (nonatomic, strong) CTCallCenter *callCenter;
@property (nonatomic, assign) BOOL currentCallState;

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
        if (CurrentSystemVersion >= 10.0) {
            _cXCallObserver = [[CXCallObserver alloc] init];
            [_cXCallObserver setDelegate:self queue:nil];
        } else {
            _callCenter = [[CTCallCenter alloc] init];
        }
    }
    return self;
}

- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
    if ([call hasConnected]) {
        self.currentCallState = YES;
    }
    if ([call hasEnded]) {
        self.currentCallState = NO;
    }
}

- (BOOL)isConnected {
    if (CurrentSystemVersion >= 10.0) {
        return self.currentCallState;
    } else {
        return self.callCenter.currentCalls.count != 0;
    }
}

@end

