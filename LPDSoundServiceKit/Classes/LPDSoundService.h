//
//  LPDSoundService.h
//  LPDSoundService
//
//  Created by PixelShi on 2017/9/12.
//  Copyright © 2017年 me.ele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LPDSoundService : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) BOOL canShake;

/**
 *  @brief play sound with file name. e.m sound.aiff
 */

- (void)playSoundWithName:(NSString *)soundName ofType:(NSString*)type;

/**
 *  @brief control the volume of AudioPlayer
 */

- (void)setAudioPlayerVolume;

/**
 *  @brief control the shake when play the sound
 */
- (void)openShake:(BOOL)canshake;

/**
 *  @brief control the cache sound
 */
- (void)needCache:(BOOL)isNeed;

@end

