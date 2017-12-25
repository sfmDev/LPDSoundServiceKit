//
//  LPDTeleponyManager.m
//  LPDSoundService
//
//  Created by PixelShi on 2017/9/13.
//  Copyright © 2017年 me.ele. All rights reserved.
//

#import "LPDTeleponyManager.h"
#import <CallKit/CXCallObserver.h>
#import <CallKit/CXCall.h>

#define CurrentSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface LPDTeleponyManager() <CXCallObserverDelegate>

@property (nonatomic, strong) CXCallObserver *cXCallObserver;
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
            dispatch_async(dispatch_get_main_queue(), ^{
                callCenter = [[CTCallCenter alloc] init];
            });
        }
    }
    return self;
}

- (void)scanPhoneCallState {
    if (CurrentSystemVersion < 10.0) {
        __weak typeof(self) weakSelf = self;
        callCenter.callEventHandler = ^(CTCall* call) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if([call.callState isEqualToString: CTCallStateDisconnected]){
                NSLog(@"Call has been disconnected");
                strongSelf.currentCallState = NO;
            } else if([call.callState isEqualToString: CTCallStateConnected]) {
                NSLog(@"Call has just been connected");
                strongSelf.currentCallState = YES;
            } else if([call.callState isEqualToString:CTCallStateIncoming]) {
                NSLog(@"Call is incoming");
                strongSelf.currentCallState = YES;
            } else if([call.callState isEqualToString:CTCallStateDialing]) {
                NSLog(@"Call is Dialing");
                strongSelf.currentCallState = YES;
            }
        };
    }
}

- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
    if ([call hasConnected]) {
        self.currentCallState = YES;
    }
    if ([call isOnHold]) {
        self.currentCallState = YES;
    }
    if ([call isOutgoing]) {
        self.currentCallState = YES;
    }
    if ([call hasEnded]) {
        self.currentCallState = NO;
    }
}

- (BOOL)isConnected {
    return self.currentCallState;
}

@end

