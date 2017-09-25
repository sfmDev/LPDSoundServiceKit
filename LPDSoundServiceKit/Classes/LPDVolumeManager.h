//
//  LPDVolumeManager.h
//  VoiceTest
//
//  Created by leon on 2017/6/5.
//  Copyright © 2017年 leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LPDVolumeManager : NSObject

@property (nonatomic,assign) CGFloat volumeValue;

+(instancetype)shareInstance;

// 耳机状态监听
- (void)setAudioChangeNotification;
// 检测耳机状态 是否插入
- (BOOL)isHeadsetPluggedIn;
// 当前音量
- (float)getCurrentVolume;
// 设置当前音量为做大
- (float)setSystemVolumeToMax;
// 移除 MPVolumeView
- (void)removeMPVolumeView;

@end
