//
//  LPDTeleponyManager.h
//  LPDSoundService
//
//  Created by PixelShi on 2017/9/13.
//  Copyright © 2017年 me.ele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface LPDTeleponyManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isConnected;

@property (nonatomic, strong) RACSignal *teleponyStateSignal;

@end
