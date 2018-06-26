//
//  Generals.swift
//  DoctorApp
//
//  Created by chola on 6/18/18.
//  Copyright © 2018 chola. All rights reserved.
//

import UIKit
import Foundation

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}


class CHGenerals: NSObject {
    
    class func stringtodate(_ str : NSString) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date : Date = dateFormatter.date(from: str as String)!
        return date
    }
    
    class func datetostring(_ date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: date)
        print(dateString)
        return dateString
    }
    
    class func datetotime(_ date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let dateString = dateFormatter.string(from: date)
        print(dateString)
        return dateString
    }
    
    class func timeformated(_ inStr : String) -> String {
        
        if inStr.range(of:":") != nil{
            print("exists")
            let inFormatter = DateFormatter()
            inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            inFormatter.dateFormat = "hh:mm a"
            
            let outFormatter = DateFormatter()
            outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            outFormatter.dateFormat = "HH:mm"
            
            //        let inStr = "16:50"
            let date = inFormatter.date(from: inStr)!
            let outStr = outFormatter.string(from: date)
            print(outStr)
            return outStr
            
        } else {
            let inFormatter = DateFormatter()
            inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            inFormatter.dateFormat = "hh a"
            
            let outFormatter = DateFormatter()
            outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            outFormatter.dateFormat = "HH:mm"
            
            //        let inStr = "16:50"
            let date = inFormatter.date(from: inStr)!
            let outStr = outFormatter.string(from: date)
            print(outStr)
            return outStr
        }
        
    }
   
}
