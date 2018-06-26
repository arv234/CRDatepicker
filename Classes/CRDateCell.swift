//
//  CRDateCell.swift
//  CRDatepicker
//
//  Created by chola on 6/26/18.
//

import UIKit

class CRDateCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.text = "label"
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.tag = 10
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    
    func addViews(){
        backgroundColor = UIColor.white
        
        addSubview(nameLabel)
        
        nameLabel.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)

        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

