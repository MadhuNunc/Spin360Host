//
//  CSCaptureViewController.h
//  360Video
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

@protocol CSCaptureViewControllerDelegate <NSObject>
@optional

/**
 * Called spinCancelAction delegate when a session capture cancel action
 */
-(void)spinCancelAction:(NSString*)message;

/**
 * Called spinCompleteAction delegate when a session successfully completed 360 capturing and pano.
 */
-(void)spinCompleteAction:(NSString*)message;
@end

@interface CSCaptureViewController : UIViewController

/**
 * Implement this delegate to be informed of the capturing complete and cancel functionalities.
 */
@property (nonatomic, weak) id<CSCaptureViewControllerDelegate> delegate;

/**
 * captureState getter to observe the current capture state
 */
@property (assign, nonatomic) NSInteger captureState;


@end

NS_ASSUME_NONNULL_END
