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
    
    var plotArray = [[Int]](repeating: [Int](repeating: 0, count: 2), count: 374)
    var XaxisArray = [Int](repeating: 0, count: 4)
    var YaxisArray = [Int](repeating: 0, count: 4)
    
    init(frame: CGRect, data: [[Int]], Xaxis: [Int], Yaxis: [Int]) {
        super.init(frame: frame)
        self.plotArray = data
        self.XaxisArray = Xaxis
        self.YaxisArray = Yaxis
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func draw(_ rect: CGRect) {
        //context is the object used for drawing
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(1)
        context.setStrokeColor(UIColor(red:0.65, green:0.65, blue:0.65, alpha:1.0).cgColor)
        
        //Draw the X-axis
        context.move(to: CGPoint(x:XaxisArray[0], y:XaxisArray[1]))
        context.addLine(to: CGPoint(x:XaxisArray[2], y:XaxisArray[3]))
        context.strokePath()
        
        //Draw the Y-axis
        context.move(to: CGPoint(x:YaxisArray[0], y:YaxisArray[1]))
        context.addLine(to: CGPoint(x:YaxisArray[2], y:YaxisArray[3]))
        context.strokePath()
        
        //Draw the plot
        context.setStrokeColor(UIColor(red:0.24, green:0.25, blue:0.58, alpha:1.0).cgColor)
        context.setLineJoin(_: CGLineJoin.round)        //does not affect anything
        context.setLineWidth(1)
        context.move(to: CGPoint(x:plotArray[0][0], y:plotArray[0][1]))
        for i in 1 ... 373 {
            context.addLine(to: CGPoint(x:plotArray[i][0], y:plotArray[i][1]))
        }
        context.strokePath()
        
        
    }
    

}
