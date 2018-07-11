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
    var axisArray = [Int](repeating: 0, count: 4)
    
    init(frame: CGRect, data: [Int], axis: [Int]) {
        super.init(frame: frame)
        self.plotArray = data
        self.axisArray = axis
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func draw(_ rect: CGRect) {
        //context is the object used for drawing
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.black.cgColor)
        
        //Create a path
        context.move(to: CGPoint(x:axisArray[0], y:axisArray[1]))
        context.addLine(to: CGPoint(x:axisArray[2], y:axisArray[3]))
        
        
        context.strokePath()
        
    }
    

}
