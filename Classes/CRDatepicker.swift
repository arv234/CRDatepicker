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

public protocol CRDatepickerDelegate {
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

public class CRDatepicker: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    var lbldate: UILabel! = UILabel()

    public var delegate: CRDatepickerDelegate?


    override public func awakeFromNib() {
        super.awakeFromNib()
        
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
        } else {
            month1 = 1
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
    
    let cancel: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(#colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1), for: .normal)
        return button
    }()
    
    let set: UIButton = {
        let button = UIButton()
        button.setTitle("Set", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(#colorLiteral(red: 0.003921568627, green: 0.3411764706, blue: 0.6078431373, alpha: 1), for: .normal)
        return button
    }()
    
    func createUI() {
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: 326, height: 400))
        myView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        myView.center = self.view.center
        self.view.addSubview(myView)
        myView.layer.cornerRadius = 5;
        myView.layer.masksToBounds = true;
        
        lbldate.frame = CGRect(x: 20, y: 400-46, width: 100, height: 46)
        lbldate.font = UIFont.systemFont(ofSize: 14)
        myView.addSubview(lbldate)
        
        cancel.frame = CGRect(x: 326-200, y: 400-46, width: 100, height: 46)
        myView.addSubview(cancel)
        cancel.addTarget(self, action: #selector(btnCancel), for: .touchUpInside)
        
        set.frame = CGRect(x: 326-100, y: 400-46, width: 100, height: 46)
        myView.addSubview(set)
        set.addTarget(self, action: #selector(btnSet), for: .touchUpInside)

        colvw(myView: myView)
        
    }
    
    var cellId = "cell"
    
    func colvw(myView : UIView) {
        // Create an instance of UICollectionViewFlowLayout since you cant
        // Initialize UICollectionView without a layout
        let layout: CRCarouselCollectionViewLayout = CRCarouselCollectionViewLayout()
//        layout.sectionInsetTop = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: myView.frame.size.width/5, height: 70)
        
        let layout1: CRCarouselCollectionViewLayout = CRCarouselCollectionViewLayout()
        //        layout.sectionInsetTop = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout1.itemSize = CGSize(width: myView.frame.size.width/5, height: 70)
        
        let layout2: CRCarouselCollectionViewLayout = CRCarouselCollectionViewLayout()
        //        layout.sectionInsetTop = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout2.itemSize = CGSize(width: myView.frame.size.width/5, height: 70)
        
        let layout3: CRCarouselCollectionViewLayout = CRCarouselCollectionViewLayout()
        //        layout.sectionInsetTop = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout3.itemSize = CGSize(width: myView.frame.size.width/5, height: 70)
        
        yearCarousel = UICollectionView(frame: CGRect(x: 0, y: 10, width: 326, height: 70), collectionViewLayout: layout)
        yearCarousel.dataSource = self
        yearCarousel.delegate = self
        yearCarousel.register(CRDateCell.self, forCellWithReuseIdentifier: cellId)
        yearCarousel.showsVerticalScrollIndicator = false
        yearCarousel.backgroundColor = UIColor.white
        yearCarousel.tag = 100
        myView.addSubview(yearCarousel)
        
        monthCarousel = UICollectionView(frame: CGRect(x: 0, y: 90, width: 326, height: 70), collectionViewLayout: layout1)
        monthCarousel.dataSource = self
        monthCarousel.delegate = self
        monthCarousel.register(CRDateCell.self, forCellWithReuseIdentifier: cellId)
        monthCarousel.showsVerticalScrollIndicator = false
        monthCarousel.backgroundColor = UIColor.white
        monthCarousel.tag = 101
        myView.addSubview(monthCarousel)
        
        dayCarousel = UICollectionView(frame: CGRect(x: 0, y: 180, width: 326, height: 70), collectionViewLayout: layout2)
        dayCarousel.dataSource = self
        dayCarousel.delegate = self
        dayCarousel.register(CRDateCell.self, forCellWithReuseIdentifier: cellId)
        dayCarousel.showsVerticalScrollIndicator = false
        dayCarousel.backgroundColor = UIColor.white
        dayCarousel.tag = 102
        myView.addSubview(dayCarousel)
        
        timeCarousel = UICollectionView(frame: CGRect(x: 0, y: 260, width: 326, height: 70), collectionViewLayout: layout3)
        timeCarousel.dataSource = self
        timeCarousel.delegate = self
        timeCarousel.register(CRDateCell.self, forCellWithReuseIdentifier: cellId)
        timeCarousel.showsVerticalScrollIndicator = false
        timeCarousel.backgroundColor = UIColor.white
        timeCarousel.tag = 103
        myView.addSubview(timeCarousel)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        createUI()
        
        self.lbldate.text = CHGenerals.datetostring(Date())
        
        yearCarousel.reloadData()
        monthCarousel.reloadData()
        dayCarousel.reloadData()
        timeCarousel.reloadData()
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year1: Int =  components.year!
        
        for i in year1 ... year1+1 {
            year.append(i)
        }
        
        dateCalc(date: date)

        
    }
    public
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public
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
    public
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CRDateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CRDateCell
        
        let label = cell.nameLabel //cell.contentView.viewWithTag(10)! as! UILabel
        
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
    public
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
    public
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
    
    @objc func btnCancel() {
        
        self.dismiss(animated: true) { 
            
        }
        
    }
    
    @objc func btnSet() {
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
    
    public class func create() -> UIViewController {
        
        let vc1 : CRDatepicker = CRDatepicker()
        vc1.modalPresentationStyle = .overCurrentContext
        return vc1
        
    }
    
    public func showCRDate(obj: UIViewController) {
        
        obj.present(self, animated: true, completion: nil)
        
    }
    
    

}

