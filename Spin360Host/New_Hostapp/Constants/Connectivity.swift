//
//  Connectivity.swift
//  Spin360Host
//
//  Created by apple on 7/24/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
