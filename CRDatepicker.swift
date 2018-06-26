//
//  ViewController.swift
//  SwiftExample
//
//  Created by chola on 6/18/18.
//  Copyright © 2018 chola. All rights reserved.
//

import UIKit


extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

protocol CRDatepickerDelegate {
    func dateUpdate(_ strDate: String)
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

class CRDatepicker: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var year: [Int] = []
    var month: [Int] = []
    var day: [Int] = []
    
    var dayString: [String] = []
    
    var time: [String] = ["8 AM", "8:30 AM", "9 AM", "9:30 AM", "10 AM", "10:30 AM", "11 AM", "11:30 AM", "12 PM", "12:30 PM", "1 PM", "1:30 PM", "2 PM", "2:30 PM", "3 PM", "3:30 PM", "4 PM", "4:30 PM", "5 PM", "5:30 PM", "6 PM", "6:30 PM", "7 PM", "7:30 PM", "8 PM", "8:30 PM", "9 PM", "9:30 PM", "10 PM", "10:30 PM"]
    
    var inxY : Int = 0
    var inxM : Int = 0
    var inxD : Int = 0
    var inxT : Int = 0

    @IBOutlet var yearCarousel: UICollectionView!
    @IBOutlet var monthCarousel: UICollectionView!
    @IBOutlet var dayCarousel: UICollectionView!
    
    @IBOutlet var timeCarousel: UICollectionView!
    
    @IBOutlet var lbldate: UILabel!

    var delegate: CRDatepickerDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year1: Int =  components.year!
        
        for i in year1 ... year1+1 {
            year.append(i)
        }
        
        dateCalc(date: date)
        
    }
    
    func currentDate() -> DateComponents {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return components
    }
    
    func dateCalc(date: Date) {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year1: Int =  components.year!
        var month1: Int = components.month!
        var day1: Int = components.day!
        
        month.removeAll()
        
        
        
        if month1 == currentDate().month! && year1 == currentDate().year!{
            day1 = currentDate().day!
        } else {
            day1 = 1
        }
        
        if year1 == currentDate().year! {
            month1 = currentDate().month!
//            day1 = 1
        } else {
            month1 = 1
//            day1 = 1
        }
        
        for i in month1 ... 12 {
            month.append(i)
        }
        
        if month.count-1 > inxM && year.count-1 > inxY  {
            
            day.removeAll()
            
            dayString.removeAll()

            let strDate = "01-\(String(format: "%02d", month[inxM]))-\(year[inxY])"
            let date1 = GetDateFromString(DateStr: strDate)
            
            for i in day1 ... getLastday(date: date1) {
                day.append(i)
                let strD = "\(String(format: "%02d", i))-\(String(format: "%02d", month[inxM]))-\(year[inxY])"
                dayString.append(getDayOfWeek(today: strD))
                
            }
            
        } else {
            
            day.removeAll()
            dayString.removeAll()
            
            for i in day1 ... getLastday(date: date) {
                day.append(i)
                let strD = "\(String(format: "%02d", i))-\(String(format: "%02d", month[inxM]))-\(year[inxY])"
                dayString.append(getDayOfWeek(today: strD))
                
            }
        }
        
        
    }
    
    func getLastday(date: Date) -> Int {
        let dateEndOfMonth = date.endOfMonth()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: dateEndOfMonth)
        let day1 = components.day
        print(components)
        return day1!
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.lbldate.text = CHGenerals.datetostring(Date())
        
        yearCarousel.reloadData()
        monthCarousel.reloadData()
        dayCarousel.reloadData()
        timeCarousel.reloadData()

        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 100 {
            return year.count
            
        } else if collectionView.tag == 101 {
            return month.count
            
        } else if collectionView.tag == 102 {
            return day.count
            
        } else if collectionView.tag == 103 {
            return time.count
            
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let label = cell.contentView.viewWithTag(10)! as! UILabel
        
        if collectionView.tag == 100 {
            label.text = "\(year[indexPath.item])"
            
        } else if collectionView.tag == 101 {
            
            let monthName = DateFormatter().monthSymbols[month[indexPath.item] - 1]
            
            label.text = monthName //"\(month[index])"
            
        } else if collectionView.tag == 102 {
            
            label.numberOfLines = 0
            
            label.text = "\(dayString[indexPath.item])" + "\n" + "\(day[indexPath.item])"
            
        } else if collectionView.tag == 103 {
            
            label.text = "\(time[indexPath.item])"
            
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        if scrollView.tag == 103 {
            
            visibleRect.origin = timeCarousel.contentOffset
            visibleRect.size = timeCarousel.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            guard let indexPath = timeCarousel.indexPathForItem(at: visiblePoint) else { return }
            inxT = indexPath.row
            
//            timeCarousel.reloadData()
            
            return
        }
        
        if scrollView.tag == 100 {
            
            visibleRect.origin = yearCarousel.contentOffset
            visibleRect.size = yearCarousel.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            guard let indexPath = yearCarousel.indexPathForItem(at: visiblePoint) else { return }
            inxY = indexPath.row
            
//            inxY = carousel.currentItemIndex
            
        } else if scrollView.tag == 101 {
            
            visibleRect.origin = monthCarousel.contentOffset
            visibleRect.size = monthCarousel.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            guard let indexPath = monthCarousel.indexPathForItem(at: visiblePoint) else { return }
            inxM = indexPath.row
            
//            inxM = carousel.currentItemIndex
            
            let strDate = "\(String(format: "%02d", day[0]))-\(String(format: "%02d", month[inxM]))-\(year[inxY])"
            let date = GetDateFromString(DateStr: strDate) //according to date format your date string
            let lastDay = getLastday(date: date)
            if inxD >= lastDay {
                inxD = lastDay-1
            }
            
            
        } else if scrollView.tag == 102 {
            
            visibleRect.origin = dayCarousel.contentOffset
            visibleRect.size = dayCarousel.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            guard let indexPath = dayCarousel.indexPathForItem(at: visiblePoint) else { return }
            inxD = indexPath.row
            
//            inxD = carousel.currentItemIndex
            
        }
        
        if scrollView.tag == 100 || scrollView.tag == 101 {
            
            if day.count > 0 && month.count > 0 && year.count > 0 {
                //            print("\(String(format: "%02d", day[inxD]))-\(String(format: "%02d", month[inxM]))-\(year[inxY])")
                
                if inxD > day.count {
                    inxD = 0
                }
                
                if inxM > month.count {
                    inxM = 0
                }
                
                let strDate = "\(String(format: "%02d", day[inxD]))-\(String(format: "%02d", month[inxM]))-\(year[inxY])"
                
                
                var date = GetDateFromString(DateStr: strDate) //according to date format your date string
                print(date )
                let dateC = Date()
                if date < dateC  {
                    print("date1 is earlier than date2")
                    date = dateC
                }
                
                dateCalc(date: date)
            }
            
        }
        
        yearCarousel.reloadData()
        monthCarousel.reloadData()
        dayCarousel.reloadData()
        
        let strD = "\(String(format: "%02d", day[inxD]))-\(String(format: "%02d", month[inxM]))-\(year[inxY])"
        lbldate.text = strD

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if collectionView.tag == 103 {
 
            inxT = indexPath.row
            
            //            timeCarousel.reloadData()
            
            return
        }
        
        if collectionView.tag == 100 {
     
            inxY = indexPath.row
            
            //            inxY = carousel.currentItemIndex
            
        } else if collectionView.tag == 101 {
            

            inxM = indexPath.row
            
            //            inxM = carousel.currentItemIndex
            
            let strDate = "\(String(format: "%02d", day[0]))-\(String(format: "%02d", month[inxM]))-\(year[inxY])"
            let date = GetDateFromString(DateStr: strDate) //according to date format your date string
            let lastDay = getLastday(date: date)
            if inxD >= lastDay {
                inxD = lastDay-1
            }
            
            
        } else if collectionView.tag == 102 {
            

            inxD = indexPath.row
            
            //            inxD = carousel.currentItemIndex
            
        }
        
        if collectionView.tag == 100 || collectionView.tag == 101 {
            
            if day.count > 0 && month.count > 0 && year.count > 0 {
                //            print("\(String(format: "%02d", day[inxD]))-\(String(format: "%02d", month[inxM]))-\(year[inxY])")
                
                if inxD > day.count {
                    inxD = 0
                }
                
                if inxM > month.count {
                    inxM = 0
                }
                
                let strDate = "\(String(format: "%02d", day[inxD]))-\(String(format: "%02d", month[inxM]))-\(year[inxY])"
                
                
                var date = GetDateFromString(DateStr: strDate) //according to date format your date string
                print(date )
                let dateC = Date()
                if date < dateC  {
                    print("date1 is earlier than date2")
                    date = dateC
                }
                
                dateCalc(date: date)
            }
            
        }
        
        yearCarousel.reloadData()
        monthCarousel.reloadData()
        dayCarousel.reloadData()
        
        let strD = "\(String(format: "%02d", day[inxD]))-\(String(format: "%02d", month[inxM]))-\(year[inxY])"
        lbldate.text = strD
        
    }
    
    func GetDateFromString(DateStr: String)-> Date
    {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        let DateArray = DateStr.components(separatedBy: "-")
        let components = NSDateComponents()
        components.year = Int(DateArray[2])!
        components.month = Int(DateArray[1])!
        components.day = Int(DateArray[0])! + 1
        let date = calendar?.date(from: components as DateComponents)
        
        return date!
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        
        self.dismiss(animated: true) { 
            
        }
        
    }
    
    @IBAction func btnSet(_ sender: Any) {
        self.dismiss(animated: true) {
            
            let strD = "\(String(format: "%02d", self.day[self.inxD]))-\(String(format: "%02d", self.month[self.inxM]))-\(self.year[self.inxY]) \(self.time[self.inxT])"
            self.delegate?.dateUpdate(strD)

        }
    }
    
    func getDayOfWeek(today:String)->String {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let todayDate = formatter.date(from: today)!
        
        return todayDate.dayOfWeek()!
        
    }
    
    class func instanceFromNib() -> UIViewController {
        
        let vc : CRDatepicker = UIStoryboard(name: "CHPickerSB", bundle: nil).instantiateViewController(withIdentifier: "CRDatepicker") as! CRDatepicker
        vc.modalPresentationStyle = .overCurrentContext
        
        return vc
    }
    
    func show(obj: UIViewController) {
        
        obj.present(self, animated: true, completion: nil)
        
    }
    
    

}

