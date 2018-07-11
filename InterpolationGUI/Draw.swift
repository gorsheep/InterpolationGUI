//
//  Draw.swift
//  InterpolationGUI
//
//  Created by Даниил Волошин on 7/11/18.
//  Copyright © 2018 Даниил Волошин. All rights reserved.
//

import UIKit
import Foundation

class Draw: UIView {
    
    var plotArray = [Int](repeating: 0, count: 374)
    
    init(frame: CGRect, data: [Int]) {
        super.init(frame: frame)
        self.plotArray = data
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func draw(_ rect: CGRect) {
        //context is the object used for drawing
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(3)
        context.setStrokeColor(UIColor.purple.cgColor)
        
        //Create a path
        context.move(to: CGPoint(x:plotArray[0], y:plotArray[1]))
        context.addLine(to: CGPoint(x:plotArray[2], y:plotArray[3]))
        
        
        context.strokePath()
        
    }
    

}
