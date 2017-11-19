//
//  LPDViewController.m
//  LPDSoundServiceKit
//
//  Created by sfm on 09/25/2017.
//  Copyright (c) 2017 ele.me. All rights reserved.
//

#import "LPDViewController.h"
#import <LPDSoundServiceKit/LPDSoundServiceKit.h>

@interface LPDViewController ()

@end

@implementation LPDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)playSoundTapped:(UIButton *)sender {
    [[LPDSoundService sharedInstance] playSoundWithName:@"remind_work" ofType:@"aiff"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
