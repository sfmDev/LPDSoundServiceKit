//
//  LPDTeleponyManager.h
//  LPDSoundService
//
//  Created by PixelShi on 2017/9/13.
//  Copyright © 2017年 me.ele. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreTelephony/CTCallCenter.h>
//#import <CoreTelephony/CTCall.h>

@interface LPDTeleponyManager : NSObject

//@property (nonatomic, strong) CTCallCenter *callCenter;

+ (instancetype)sharedInstance;

//- (void)scanPhoneCallState;

- (BOOL)isConnected;

@end
