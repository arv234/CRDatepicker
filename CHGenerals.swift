//
//  Generals.swift
//  DoctorApp
//
//  Created by chola on 6/18/18.
//  Copyright © 2018 chola. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import CoreTelephony

extension String {
    func dropLast(_ n: Int = 1) -> String {
        return String(characters.dropLast(n))
    }
    var dropLast: String {
        return dropLast()
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }

}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

extension UIView {

    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
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
