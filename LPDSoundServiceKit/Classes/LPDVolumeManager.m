//
//  LPDVolumeManager.m
//  VoiceTest
//
//  Created by leon on 2017/6/5.
//  Copyright © 2017年 leon. All rights reserved.
//

#import "LPDVolumeManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LPDSoundService.h"
#import <LPDControlsKit/LPDToastView.h>

@interface LPDVolumeManager()

@property (nonatomic, strong) MPVolumeView *mpVolumeView;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation LPDVolumeManager

@synthesize volumeValue = _volumeValue;

+(instancetype)shareInstance {
    static LPDVolumeManager *_instance =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance==nil) {
            _instance = [[LPDVolumeManager alloc] init];
        }
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadMPVolumeView];
    }
    return self;
}

- (void)loadMPVolumeView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.mpVolumeView];
}

- (void)setAudioChangeNotification{
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)audioRouteChangeListenerCallback:(NSNotification*)notification{
    // 插拔耳机是暂停播放0.1s
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[LPDSoundService sharedInstance] audioPlayer] pause];
        NSDictionary *interuptionDict = notification.userInfo;
        NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
        [[LPDSoundService sharedInstance] setAudioPlayerVolume];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[[LPDSoundService sharedInstance] audioPlayer] play];
        });

        switch (routeChangeReason) {
            case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
                [LPDToastView show:@"进入耳机模式"];
                break;
            case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
                [LPDToastView show:@"退出耳机模式"];
                break;
            default:
                break;
        }
    });
}

- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones]) {
            return YES;
        } else if ([[desc portType] isEqualToString:AVAudioSessionPortBluetoothLE]) {
            return YES;
        } else if ([[desc portType] isEqualToString:AVAudioSessionPortBluetoothA2DP]) {
            return YES;
        } else if ([[desc portType] isEqualToString:AVAudioSessionPortBluetoothHFP]) {
            return YES;
        } else if ([[desc portType] isEqualToString:AVAudioSessionPortAirPlay]) {
            return YES;
        }
    }
    return NO;
}

- (float)getCurrentVolume {
    return [AVAudioSession sharedInstance].outputVolume;
}

- (void)removeMPVolumeView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *subView in window.subviews) {
        if ([subView isEqual: self.mpVolumeView]) {
            [self.mpVolumeView removeFromSuperview];
            self.mpVolumeView = nil;
        }
    }
}

#pragma mark private methods
-(void) generateMPVolumeSlider {
    for (UIView *view in [self.mpVolumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.slider = (UISlider*)view;
            break;
        }
    }
}

#pragma mark setters
-(void) setVolumeValue:(CGFloat) newValue{
    _volumeValue = newValue;
    if (!self.slider) {
        [self generateMPVolumeSlider];
    }
    [self.slider setValue:newValue animated:NO];
    [self.slider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

/*
 // https://mp.weixin.qq.com/s/yYCaPMxHGT9LyRyAPewVWQ
 - (void)setSystemVolume:(float)volume {
 UISlider* volumeViewSlider = nil;
 for (UIView *view in [self.mpVolumeView subviews]){
 if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
 self.slider = (UISlider*)view;
 break;
 }
 }
 if (volumeViewSlider != nil) {
 [volumeViewSlider setValue:volume animated:NO];        //通过send
 [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
 }
 }
 */

#pragma mark getters
-(CGFloat) volumeValue {
    if (!self.slider) {
        [self generateMPVolumeSlider];
    }
    if (_volumeValue == 0) {
         return [self getCurrentVolume];
    } else {
        return self.slider.value;
    }
}

-(MPVolumeView *) mpVolumeView {
    if (!_mpVolumeView) {
        _mpVolumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-100, -100, 100, 100)];
    }
    return _mpVolumeView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

