////
////  SystemConfiguration.swift
////  netflixUIKit
////
////  Created by Muhammad Fahmi on 10/11/23.
////
//
//import Foundation
//import SystemConfiguration
//
//func isNetworkAvailable() -> Bool {
//    var zeroAddress = sockaddr()
//    zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
//    zeroAddress.sa_family = sa_family_t(AF_INET)
//    
//    // Use the proper type conversion for the closure
//    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { ptr in
//            SCNetworkReachabilityCreateWithAddress(nil, ptr)
//        }
//    } else {
//        return false
//    }
//    
//    var flags: SCNetworkReachabilityFlags = []
//    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
//        return false
//    }
//    
//    let isReachable = flags.contains(.reachable)
//    let needsConnection = flags.contains(.connectionRequired)
//    
//    return isReachable && !needsConnection
//}
