//
//  Spin360Constants.swift
//  Spin360Host
//
//  Created by apple on 6/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

enum CAPTURE_STATE: NSInteger {
    case CAPTURE_360_STATE = 1, PROCESS_STATE, PREVIEW_STATE, UPLOAD_STATE, PANO_STATE, PANO_PREVIEW_STATE, PANO_UPLOAD_STATE
}

enum LOG_TYPE: NSInteger {
    case LOG_ERROR = 1, LOG_WARN, LOG_INFO, LOG_DEBUG, LOG_TRACE
}

class Constants: NSObject {
    static let CAPTURE_360 = "Capture 360"
    static let PROCESS_360 = "Process 360"
    static let PREVIEW_360 = "Preview 360"
    static let UPLOAD_360 = "Upload 360"
    static let PANO = "Pano"
    static let PREVIEW_PANO = "Preview Pano"
    static let UPLOAD_PANO = "Upload Pano"
    static let LOGGING = "Logging"
    static let CAPTURE_VIEW_CONTROLLER = "360 Capture"
    static let PANO_VIEW_CONTROLLER = "Pano Capture"
    static let SPIN_360_LIST = "360 Spin List"
    static let PANO_LIST = "Pano List"
    static let SPIN_360 = "360 Spin"
    static let PROCESS_VIEW_CONTROLLER = "360 Process"
    static let PRIVIEW_VIEW_CONTROLLER = "360 Preview"
    static let UPLOAD_VIEW_CONTROLLER = "360 Upload"
    static let PANO_PREVIEW_VIEW_CONTROLLER = "Pano Preview"
    static let PANO_UPLOAD_CONTROLLER = "Pano Upload"
    static let COMPLETED = "Completed"
    static let PENDING = "Pending"
    static let CAPTURING_COMPLETED = "Capture completed"
    static let PANO_COMPLETED = "Pano Completed"
    static let PROCESSING_COMPLETED = "Process completed"
    static let UPLOADING_COMPLETED = "Upload Completed"
    static let PANO_UPLOADING_COMPLETED = "Upload Completed"
    static let PANO_PREVIEW_COMPLETED = "Preview Completed"
    static let PANO_CANCELLED = "Pano cancelled"
    static let PANO_PREVIEW_CLOSED = "Preview closed"
    static let PANO_UPLOAD_CANCELLED = "Upload cancelled"
    static let LOG_ERROR = "Error"
    static let LOG_WARN = "Warn"
    static let LOG_INFO = "Info"
    static let LOG_DEBUG = "Debug"
    static let LOG_TRACE = "Trace"
    static let UPLOAD_CANCELLED = "Upload Cancelled"
    static let PROCESS_CANCELLED = "Process Cancelled"
}
