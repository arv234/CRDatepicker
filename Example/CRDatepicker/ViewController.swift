//
//  ViewController.swift
//  CRDatepicker
//
//  Created by chola on 06/25/2018.
//  Copyright (c) 2018 chola. All rights reserved.
//

import UIKit
import CRDatepicker

class ViewController: UIViewController, CRDatepickerDelegate {
    
    func dateUpdate(_ strDate: String) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let vc : CRDatepicker = CRDatepicker.create() as! CRDatepicker
        vc.delegate = self
        vc.showCRDate(obj: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

