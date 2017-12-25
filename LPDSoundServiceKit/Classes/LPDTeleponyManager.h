//
//  LPDTeleponyManager.h
//  LPDSoundService
//
//  Created by PixelShi on 2017/9/13.
//  Copyright © 2017年 me.ele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

static CTCallCenter *callCenter;

@interface LPDTeleponyManager : NSObject

+ (instancetype)sharedInstance;

- (void)scanPhoneCallState;

- (BOOL)isConnected;

@end
