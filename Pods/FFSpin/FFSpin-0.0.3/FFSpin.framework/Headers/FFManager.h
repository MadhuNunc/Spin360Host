//
//  FFManager.h
//  Capture360Demo
//
//  Created by apple on 6/13/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FFManagerDelegate <NSObject>
@optional
/**
 * Called uploadProgress delegate to update 360 capture/ pano upload progress and capture state
 */
-(void)uploadProgress:(float)progress andCaptureState:(NSInteger)captureState;

/**
 * Called updateProgress delegate to update 360 capture process elapsed time and capture state
 */
-(void)updateProgress:(int)progressStage andCaptureState:(NSInteger)captureState;

/**
 * Called updateLogWithLogType delegate to update log type and message
 */
-(void)updateLogWithLogType:(NSInteger)logType andMessage:(NSString*_Nullable)message;
@end

NS_ASSUME_NONNULL_BEGIN

@interface FFManager : NSObject

/**
 * Implement this delegate to be informed of the upload, process and log functionalities.
 */
@property (nonatomic, assign) id <FFManagerDelegate> delegate;

/**
 * captureState getter to observe the current capture state
 */
@property (assign, nonatomic) NSInteger captureState;

/**
 * logType getter to observe the current log type
 */
@property (assign, nonatomic) NSInteger logType;

/**
 * updateTimer getter to observe the current process and upload progress
 */
@property(nonatomic,strong) NSTimer *updateTimer;

+ (FFManager *)sharedService;

/**
 * @summary Called startProgressAndObject action to start 360 capture process/upload and pano upload
 *
 * @param captureState is to identify the capture state
 */
-(void)startProgressAndObject:(id)object andCaptureState:(NSInteger)captureState;

/**
 * Called stopProgress action to stops process and upload
 */
-(void)stopProgress;

/**
 * @summary Called updateLogAndObject action to execute logs
 *
 * @param logType is to identify the log type
 */
-(void)updateLogAndObject:(id)object andLogType:(NSInteger)logType;

@end

NS_ASSUME_NONNULL_END
