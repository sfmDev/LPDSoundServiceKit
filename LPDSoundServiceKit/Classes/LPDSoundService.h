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

/**
 *  @brief play sound with file name. e.m sound.aiff
 */

- (void)playSoundWithName:(NSString *)soundName ofType:(NSString*)type;

/**
 *  @brief control the volume of AudioPlayer
 */

- (void)setAudioPlayerVolume;

@end
