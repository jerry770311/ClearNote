//
//  StrikeThroughText.swift
//  ClearNote
//
//  Created by apple on 2018/10/14.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import QuartzCore


class StrikeThroughText: UITextField {

    let strikeThroughLayer : CALayer
    
    var strikeThrough : Bool{
        didSet{
            strikeThroughLayer.isHidden = !strikeThrough
            if strikeThrough{
                 resizeStrikeThrough()
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        strikeThroughLayer = CALayer()
        strikeThroughLayer.backgroundColor = UIColor.white.cgColor
        strikeThroughLayer.isHidden = true
        strikeThrough = false
        super.init(frame: frame)
        layer.addSublayer(strikeThroughLayer)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeStrikeThrough()
    }
    let kStrikeOutThickness: CGFloat = 2.0
    func resizeStrikeThrough(){
        let textSize = text!.size(withAttributes: [NSAttributedString.Key.font : font!])
        strikeThroughLayer.frame = CGRect(x: 0, y: bounds.size.height/2, width: textSize.width, height: kStrikeOutThickness)
    }
}
