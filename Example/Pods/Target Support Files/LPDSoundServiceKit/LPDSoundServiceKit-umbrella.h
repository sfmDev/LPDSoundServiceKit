#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LPDSoundService.h"
#import "LPDSoundServiceKit.h"
#import "LPDTeleponyManager.h"
#import "LPDVolumeManager.h"

FOUNDATION_EXPORT double LPDSoundServiceKitVersionNumber;
FOUNDATION_EXPORT const unsigned char LPDSoundServiceKitVersionString[];

