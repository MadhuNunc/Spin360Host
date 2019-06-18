//
//  FFCamera.h
//  360Spin
//
//  Created by apple on 5/23/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN


/**
 * Capture states used for identifying a capture session.
 */
typedef enum captureStateTypes
{
    CAPTURE_360 = 1,
    PROCESS_360,
    PREVIEW_360,
    UPLOAD_360,
    PANO_360,
    PANO_PREVIEW,
    PANO_UPLOAD
} CaptureState;

@protocol FFCameraDelegate <NSObject>
@optional

/**
 * Called spinDidCancelAction delegate when a session capture cancel action
 */
-(void)spinDidCancelAction:(NSString*)message;

/**
 * Called spinDidCompleteAction delegate when a session successfully completed 360 capturing and pano.
 */
-(void)spinDidCompleteAction:(NSString*)message spinGUID:(NSString*)guid fromDirectory:(NSString*)documentsPath;

/**
 * Called spinCapturingFailed delegate when a session failed 360/pano capturing.
 */
-(void)spinCapturingFailed:(NSString*)failureMessage;

@end

@interface FFCamera : UIViewController

/**
 * Implement this delegate to be informed of the capturing complete and cancel functionalities.
 */
@property (nonatomic, weak) id<FFCameraDelegate> delegate;

/**
 * captureState getter to observe the current capture state
 */
@property (assign, nonatomic) NSInteger captureState;

/**
 * spinGuid getter for unique identifier to save the spin360/pano
 */
@property (strong, nonatomic) NSString *spinGuid;

/**
 * documentsPath getter using to save the spin360/pano
 */
@property (strong, nonatomic) NSString *documentsPath;

@end

NS_ASSUME_NONNULL_END
