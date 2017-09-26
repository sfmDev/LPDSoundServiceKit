//
//  LPDSoundService.m
//  LPDSoundService
//
//  Created by PixelShi on 2017/9/12.
//  Copyright © 2017年 me.ele. All rights reserved.
//

#import "LPDSoundService.h"
#import <UIKit/UIKit.h>
#import "LPDSoundService.h"
#import "LPDVolumeManager.h"
#import "LPDTeleponyManager.h"
#import <AudioToolbox/AudioToolbox.h>

@interface LPDSoundItem : NSObject

@property (nonatomic, assign) NSTimeInterval latestPlay;
@property (nonatomic, assign) SystemSoundID soundId;

@end

@implementation LPDSoundItem

@end

@interface LPDSoundService () <AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableDictionary *dictionaryOfSoundNameId;
@property (nonatomic, strong) NSString *cacheSoundName;
@property (nonatomic, strong) NSString *cacheSoundType;
@property (nonatomic, strong) NSMutableArray<NSString *> *cacheSounds;
@property (nonatomic, assign) BOOL isPlaying;

@end

@implementation LPDSoundService

+ (instancetype)sharedInstance {
    static LPDSoundService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LPDSoundService alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cacheSounds = [NSMutableArray array];
        self.canShake = YES;
        [self setupNotifications];
        [[[LPDTeleponyManager sharedInstance] teleponyStateSignal] subscribeCompleted:^{
            [self playCacheSound];
        }];
    }
    return self;
}

- (void)playSoundWithName:(NSString *)soundName ofType:(NSString*)type {
    if ([[LPDTeleponyManager sharedInstance] isConnected]) {
        [self shakeWhenPlaying];
        self.cacheSoundType = type;
        [self.cacheSounds addObject:soundName];
        return;
    }
    if (self.isPlaying == YES) {
        self.cacheSoundType = type;
        [self.cacheSounds addObject:soundName];
        return;
    }

    self.isPlaying = YES;

    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDuckOthers | AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    [self setOutputWith:session];

    [session setActive:YES error:nil];
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundName ofType:type]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.delegate = self;
    [self setAudioPlayerVolume];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    [self shakeWhenPlaying];
}

// 控制扬声器输出还是默认
// https://developer.apple.com/library/content/qa/qa1754/_index.html
- (void)setOutputWith:(AVAudioSession *)session {
    if ([[LPDVolumeManager shareInstance] isHeadsetPluggedIn]) {
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    } else {
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
}

// 控制声音大小
- (void)setAudioPlayerVolume {
    if ([[LPDVolumeManager shareInstance] isHeadsetPluggedIn]) {
        self.audioPlayer.volume = [[LPDVolumeManager shareInstance] getCurrentVolume];
    } else {
        self.audioPlayer.volume = [[LPDVolumeManager shareInstance] volumeValue];
    }
}

// 控制播放时候震动
// 若无震动: https://www.zhihu.com/question/51285954?from=profile_question_card
- (void)shakeWhenPlaying {
    if (self.canShake) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

//播放完成回调
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag && self.audioPlayer == player) {
        [[AVAudioSession sharedInstance] setActive:NO
                                       withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                             error:nil];
        if (self.isPlaying) {
            self.isPlaying = NO;
            [self playCacheSound];
        }
    } else {
        // log
    }
}

- (void)openShake:(BOOL)canshake {
    self.canShake = canshake;
}

- (void)playCacheSound {
    self.isPlaying = NO;
    NSArray *cache = [NSArray arrayWithArray: self.cacheSounds];
    for (NSString *soundName in cache) {
        [self.cacheSounds removeObject:soundName];
        [self playSoundWithName:soundName ofType:self.cacheSoundType];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    if (error) {
        // log
        [self playSoundWithName:self.cacheSoundName ofType:self.cacheSoundType];
    }
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(interrupted:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object: [AVAudioSession sharedInstance]];
}

-(void)interrupted:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo.count > 0) {
        if ([[userInfo objectForKey:AVAudioSessionSilenceSecondaryAudioHintTypeKey] isKindOfClass:[NSNumber class]]) {
            AVAudioSessionSilenceSecondaryAudioHintType typeValue = [[userInfo objectForKey:AVAudioSessionSilenceSecondaryAudioHintTypeKey] integerValue];
            if (typeValue == AVAudioSessionSilenceSecondaryAudioHintTypeBegin) {
                if([self.audioPlayer isPlaying]) {
                    [self.audioPlayer pause];
                }
            } else {
                if (![self.audioPlayer isPlaying]) {
                    [self.audioPlayer play];
                }
            }
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
