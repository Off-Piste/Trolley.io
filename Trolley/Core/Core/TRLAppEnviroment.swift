//
//  TRLAppEnviroment.swift
//  Pods
//
//  Created by Harry Wright on 14.06.17.
//
//

import Foundation

class TRLAppEnviroment : AnyObject, CustomStringConvertible {
    
    static var current: TRLAppEnviroment = TRLAppEnviroment()
    
    var deviceModel: String {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!
            .trimmingCharacters(in: .controlCharacters)
    }
    
    var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    var appVersionNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    var isSimulator: Bool {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return true
        #else
            return false
        #endif
    }
    
    var description: String {
        let objPtr = Unmanaged.passUnretained(self).toOpaque()
        let onePtr = UnsafeMutableRawPointer(bitPattern: 1)!  // 1 used instead of 0 to avoid crash
        let rawAddress : Int64 = Int64(onePtr.distance(to: objPtr)) + Int64(1)
        return "<TRLAppEnviroment: 0x\(rawAddress)>{ Device Model: \(self.deviceModel) System Version: \(self.systemVersion) }"
    }
    
}
