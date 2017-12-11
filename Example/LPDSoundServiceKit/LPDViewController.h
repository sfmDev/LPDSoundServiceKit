//
//  LPDViewController.h
//  LPDSoundServiceKit
//
//  Created by sfm on 09/25/2017.
//  Copyright (c) 2017 ele.me. All rights reserved.
//

@import UIKit;
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface LPDViewController : UIViewController

@property(nonatomic,strong)CTCallCenter *callCenter; //必须在这里声明，要不不会回调block

@end
