//
//  ViewController.swift
//  InterpolationGUI
//
//  Created by Даниил Волошин on 7/11/18.
//  Copyright © 2018 Даниил Волошин. All rights reserved.
//

import UIKit
import Foundation


var plotArray = [Float](repeating: 0, count: 374)                              //array that contains raw data
var positivePlotArray = [Float](repeating: 0, count: 374)                      //array that contains raw data but starts from 0
var integerPositivePlotArray = [Float](repeating: 0, count: 374)               //array that contains positive integers data
var points = [[Int]](repeating: [Int](repeating: 0, count: 2), count: 374)     //array that contains transformed data
var Xaxis = [Int](repeating: 0, count: 4)                                      //array that contains coordinates for the X-axis
var Yaxis = [Int](repeating: 0, count: 4)                                      //array that contains coordinates for the Y-axis
var choice: String = ""                                                        //variable that contains a string from the pickerView
var allGood: Bool = false                                                      //variable that checks that input is correct

//Arrays with original data
let alpha: [Float] = [-4,0,4,8,12]
let beta: [Float] = [-4,-2,0,2,4]
let mach: [Float] = [0.2,0.8,1.3,1.7,2,2.3]
let y: [Float] = [0.0000,0.0910,0.2180,0.3340,0.4560,0.5720,0.6990,0.8210,0.9350,1.0530,1.1780,1.2950,1.4160,1.5420,1.6560,1.7710,1.9010,2.0120,2.1320,2.2560,2.3730,2.4920,3.0000,4.0000,5.0000,6.0000,7.0000,9.0000,11.0000]
let x: [Float] = [-4,0,4]

//Arrays for storing temporary data
var arrayY = [[Float]](repeating: [Float](repeating: 0, count: 5), count: 870)
var arrayMach = [[Float]](repeating: [Float](repeating: 0, count: 5), count: 30)
var arrayBeta = [[Float]](repeating: [Float](repeating: 0, count: 5), count: 5)
var arrayAlpha = [Float](repeating: 0, count: 5)
var answer: Float = 3.14

//Variables for storing input
var X: Float = 0
var Y: Float = 0
var Mach: Float = 0
var Beta: Float = 0
var Alpha: Float = 0

//Variables for storing delta-values (for plotting)
let deltaAlpha: Float = (alpha[4]-alpha[0])/374
let deltaBeta: Float = (beta[4]-beta[0])/374
let deltaMach: Float = (mach[5]-mach[0])/374
let deltaY: Float = (y[28]-y[0])/374
let deltaX: Float = (x[2]-x[0])/374





//Function that interpolates
func interpol(a: Float, b: Float, c: Float, za: Float, zb: Float) -> Float {
    return za+(c-a)/(b-a)*(zb-za)
}


//Function that eliminates X
func elimX(array1: [[Float]], array2: inout [[Float]], x: Float) {
    if x<0 {
        for i in 0 ... 869 {
            for j in 0 ... 4 {
                array2[i][j]=interpol(a: -4, b: 0, c: x, za: 0, zb: array1[i][j])
            }
        }
    }
    if x>0 {
        for i in 0 ... 869 {
            for j in 0 ... 4 {
                array2[i][j]=interpol(a: 0, b: 4, c: x, za: array1[i][j], zb: 0)
            }
        }
    }
    if x==0 {
        for i in 0 ... 869 {
            for j in 0 ... 4 {
                array2[i][j]=array1[i][j]
            }
        }
    }
}


//Function that eliminates Y
func elimY(array1: [[Float]], array2: inout [[Float]], g: [Float], y: Float) {
    var a, b, za, zb: Float; a=0; b=0; za=0; zb=0;
    var q=0
    var isPresent = false
    for i in 0 ... 28 {
        if y==g[i] {
            isPresent=true
            q=i
        }
    }
    if isPresent==false {
        for i in 1 ... 28 {
            if y>g[i-1] && y<g[i] {
                a=g[i-1]
                b=g[i]
                q=i
            }
        }
    }
    
    if isPresent==true {
        var k=0
        for i in 30*(q+1)-29-1 ... 30*(q+1)-1 {
            for j in 0 ... 4 {
                array2[k][j]=array1[i][j]
            }
            k=k+1
        }
    }
    
    if isPresent==false {
        var k=0
        for i in 30*q-29-1 ... 30*q-1 {
            for j in 0 ... 4 {
                za=array1[i][j]
                zb=array1[i+30][j]
                array2[k][j]=interpol(a: a, b: b, c: y, za: za, zb: zb)
            }
            k=k+1
        }
    }
}


//Function that eliminates Mach
func elimMach(array1: [[Float]], array2: inout [[Float]], g: [Float], mach: Float) {
    var a, b, za, zb: Float; a=0; b=0; za=0; zb=0;
    var q=0
    var isPresent = false
    for i in 0 ... 5 {
        if mach==g[i] {
            isPresent=true
            q=i
        }
    }
    if isPresent==false {
        for i in 1 ... 5 {
            if mach>g[i-1] && mach<g[i] {
                a=g[i-1]
                b=g[i]
                q=i
            }
        }
    }
    
    if isPresent==true {
        var k=0
        for i in 5*(q+1)-4-1 ... 5*(q+1)-1 {
            for j in 0 ... 4 {
                array2[k][j]=array1[i][j]
            }
            k=k+1
        }
    }
    
    if isPresent==false {
        var k=0
        for i in 5*q-4-1 ... 5*q-1 {
            for j in 0 ... 4 {
                za=array1[i][j]
                zb=array1[i+5][j]
                array2[k][j]=interpol(a: a, b: b, c: mach, za: za, zb: zb)
            }
            k=k+1
        }
    }
}


//Function that eliminates Beta
func elimBeta(array1: [[Float]], array2: inout [Float], g: [Float], beta: Float) {
    var a, b, za, zb: Float; a=0; b=0; za=0; zb=0;
    var q=0
    var isPresent = false
    for i in 0 ... 4 {
        if beta==g[i] {
            isPresent=true
            q=i
        }
    }
    if isPresent==false {
        for i in 1 ... 4 {
            if beta>g[i-1] && beta<g[i] {
                a=g[i-1]
                b=g[i]
                q=i
            }
        }
    }
    
    if isPresent==true {
        for j in 0 ... 4 {
            array2[j]=array1[q][j]
        }
    }
    
    if isPresent==false {
        for j in 0 ... 4 {
            za=array1[q-1][j]
            zb=array1[q][j]
            array2[j]=interpol(a: a, b: b, c: beta, za: za, zb: zb)
        }
    }
}


//Function that eliminates Alpha
func elimAlpha(array1: [Float], answer: inout Float, g: [Float], alpha: Float) {
    var a, b, za, zb: Float; a=0; b=0; za=0; zb=0;
    var q=0
    var isPresent = false
    for i in 0 ... 4 {
        if alpha==g[i] {
            isPresent=true
            q=i
        }
    }
    if isPresent==false {
        for i in 1 ... 4 {
            if alpha>g[i-1] && alpha<g[i] {
                a=g[i-1]
                b=g[i]
                q=i
            }
        }
    }
    
    if isPresent==true {
        answer=array1[q]
    }
    
    if isPresent==false {
        za=array1[q-1]
        zb=array1[q]
        answer=interpol(a: a, b: b, c: alpha, za: za, zb: zb)
    }
}


//Function that finds the max number in an array
func max(a: [Float]) -> Float {
    let size = a.count
    var max = a[0];
    for i in 1 ... size-1 {
        if (a[i]>max) {
            max=a[i];
        }
    }
    return max;
}


//Function that finds the min number in an array
func min(a: [Float]) -> Float {
    let size = a.count
    var min = a[0];
    for i in 1 ... size-1 {
        if (a[i]<min) {
            min=a[i];
        }
    }
    return min;
}



class ViewController: UIViewController {
    
    //Declaration of labels
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    @IBOutlet var label4: UILabel!
    
    //Declaration of text boxes
    @IBOutlet var textField1: UITextField!
    @IBOutlet var textField2: UITextField!
    @IBOutlet var textField3: UITextField!
    @IBOutlet var textField4: UITextField!
    @IBOutlet var textField5: UITextField!
    @IBOutlet var textField6: UITextField!
    @IBOutlet var pickerView1: UIPickerView!
    
    let vars = ["alpha","beta","mach","Y","X"]
    var selectedVar: String?
    
    //Runs only 1 time when you first launch the app
    override func viewDidLoad() {
        super.viewDidLoad()
        label2.text = ""
        label3.text = ""
        label4.text = ""
        textField1.text = ""
        textField2.text = ""
        textField3.text = ""
        textField4.text = ""
        textField5.text = ""
        textField1.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField2.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField3.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField4.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField5.keyboardType = UIKeyboardType.numbersAndPunctuation
        createVarPicker()
        createToolbar()
    }
    
    func createVarPicker() {
        let varPicker = UIPickerView()
        varPicker.delegate = self
        textField6.inputView = varPicker
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField6.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    @IBAction func button1Pressed(_ sender: Any) {
        self.textField1.resignFirstResponder()
        self.textField2.resignFirstResponder()
        self.textField3.resignFirstResponder()
        self.textField4.resignFirstResponder()
        self.textField5.resignFirstResponder()
        
        //Fill the "data" array
        fillTheArray()
        
        if (textField1.text != "") && (textField2.text != "") && (textField3.text != "") && (textField4.text != "") && (textField5.text != "") {
            
            //Fill the variables for input values
            X = Float(textField5.text!) ?? 666
            Y = Float(textField4.text!) ?? 666
            Mach = Float(textField3.text!) ?? 666
            Beta = Float(textField2.text!) ?? 666
            Alpha = Float(textField1.text!) ?? 666
            
            if (X != 666) && (Y != 666) && (Mach != 666) && (Beta != 666) && (Alpha != 666) {
                if (Alpha < -4) || (Alpha > 12) {
                    label2.text = "ERROR: alpha out of range"
                }
                else if (Beta < -4) || (Beta > 4) {
                    label2.text = "ERROR: beta out of range"
                }
                else if (Mach < 0.2) || (Mach > 2.3) {
                    label2.text = "ERROR: mach out of range"
                }
                else if (Y < 0) || (Y > 11) {
                    label2.text = "ERROR: Y out of range"
                }
                else if (X < -4) || (X > 4) {
                    label2.text = "ERROR: X out of range"
                }
                else {
                    allGood = true
                    elimX(array1: data,array2: &arrayY, x: X);
                    elimY(array1: arrayY, array2: &arrayMach, g: y, y: Y);
                    elimMach(array1: arrayMach, array2: &arrayBeta, g: mach, mach: Mach);
                    elimBeta(array1: arrayBeta, array2: &arrayAlpha, g: beta, beta: Beta);
                    elimAlpha(array1: arrayAlpha, answer: &answer, g: alpha, alpha: Alpha);
                    label2.text = "mz = \(answer)"
                }
            } else {
                label2.text = "Please, enter numbers"
            }
            
            
        } else {
            label2.text = "Please, enter all the values"
        }
        
    
    }
    
    
    
    
    
    
    @IBAction func button2Pressed(_ sender: Any) {
        
        if allGood == true {
            switch choice {
            case "alpha":
                for i in 0 ... 373 {
                    elimX(array1: data,array2: &arrayY, x: X);
                    elimY(array1: arrayY, array2: &arrayMach, g: y, y: Y);
                    elimMach(array1: arrayMach, array2: &arrayBeta, g: mach, mach: Mach);
                    elimBeta(array1: arrayBeta, array2: &arrayAlpha, g: beta, beta: Beta);
                    elimAlpha(array1: arrayAlpha, answer: &answer, g: alpha, alpha: alpha[0]+deltaAlpha*Float(i));
                    plotArray[i]=answer
                }
                Yaxis[0] = 93 ; Yaxis[1] = 1 ; Yaxis[2] = 93 ; Yaxis[3] = 201
                label3.text = "-4"
                label4.text = "12"
                for i in 0 ... 373 {
                    positivePlotArray[i] = plotArray[i]+(-min(a: plotArray))
                }
                print("min = \(min(a: positivePlotArray))")
                print("max = \(max(a: positivePlotArray))")
                var scale: Float
                if max(a: positivePlotArray) == 0 {
                    scale = 1
                } else {
                    scale = (200/max(a: positivePlotArray))
                }
                scale.round(.down)
                print("scale = \(scale)")
                
                for i in 1 ... 374 {
                    integerPositivePlotArray[i-1] = positivePlotArray[i-1]*scale
                    integerPositivePlotArray[i-1].round(.down)
                    points[i-1]=[i,201-Int(integerPositivePlotArray[i-1]+1)]
                }
                
                var Xcoordinate: Float = scale*(-min(a: plotArray))
                Xcoordinate.round(.down)
                Xaxis[0] = 1 ; Xaxis[1] = 201 - Int(Xcoordinate) ; Xaxis[2] = 374;  Xaxis[3] = 201 - Int(Xcoordinate)
                if Xaxis[1]<=2 {                                //used to be <=0 but then changed to <=2 so that the plot looks nice
                    Xaxis[1] = 1
                    Xaxis[3] = 1
                }
                if Xaxis[1]>201 {
                    Xaxis[1] = 201
                    Xaxis[3] = 201
                }
                
                
            case "beta":
                for i in 0 ... 373 {
                    elimX(array1: data,array2: &arrayY, x: X);
                    elimY(array1: arrayY, array2: &arrayMach, g: y, y: Y);
                    elimMach(array1: arrayMach, array2: &arrayBeta, g: mach, mach: Mach);
                    elimBeta(array1: arrayBeta, array2: &arrayAlpha, g: beta, beta: beta[0]+deltaBeta*Float(i));
                    elimAlpha(array1: arrayAlpha, answer: &answer, g: alpha, alpha: Alpha);
                    plotArray[i]=answer
                }
                Yaxis[0] = 187 ; Yaxis[1] = 1 ; Yaxis[2] = 187 ; Yaxis[3] = 201
                label3.text = "-4"
                label4.text = "4"
                for i in 0 ... 373 {
                    positivePlotArray[i] = plotArray[i]+(-min(a: plotArray))
                }
                print("min = \(min(a: positivePlotArray))")
                print("max = \(max(a: positivePlotArray))")
                let scale: Float = 1
                print("scale = \(scale)")
                
                for i in 1 ... 374 {
                    integerPositivePlotArray[i-1] = positivePlotArray[i-1]*scale
                    integerPositivePlotArray[i-1].round(.down)
                    points[i-1]=[i,201-Int(integerPositivePlotArray[i-1]+1)]
                }
                
                
            case "mach":
                for i in 0 ... 373 {
                    elimX(array1: data,array2: &arrayY, x: X);
                    elimY(array1: arrayY, array2: &arrayMach, g: y, y: Y);
                    elimMach(array1: arrayMach, array2: &arrayBeta, g: mach, mach: mach[0]+deltaMach*Float(i));
                    elimBeta(array1: arrayBeta, array2: &arrayAlpha, g: beta, beta: Beta);
                    elimAlpha(array1: arrayAlpha, answer: &answer, g: alpha, alpha: Alpha);
                    plotArray[i]=answer
                }
                Yaxis[0] = 1 ; Yaxis[1] = 1 ; Yaxis[2] = 1 ; Yaxis[3] = 201
                label3.text = "0.2"
                label4.text = "2.3"
                for i in 0 ... 373 {
                    positivePlotArray[i] = plotArray[i]+(-min(a: plotArray))
                }
                print("min = \(min(a: positivePlotArray))")
                print("max = \(max(a: positivePlotArray))")
                var scale: Float
                if max(a: positivePlotArray) == 0 {
                    scale = 1
                } else {
                    scale = (200/max(a: positivePlotArray))
                }
                scale.round(.down)
                print("scale = \(scale)")
                
                for i in 1 ... 374 {
                    integerPositivePlotArray[i-1] = positivePlotArray[i-1]*scale
                    integerPositivePlotArray[i-1].round(.down)
                    points[i-1]=[i,201-Int(integerPositivePlotArray[i-1]+1)]
                }
                
                var Xcoordinate: Float = scale*(-min(a: plotArray))
                Xcoordinate.round(.down)
                Xaxis[0] = 1 ; Xaxis[1] = 201 - Int(Xcoordinate) ; Xaxis[2] = 374;  Xaxis[3] = 201 - Int(Xcoordinate)
                if Xaxis[1]<=2 {
                    Xaxis[1] = 1
                    Xaxis[3] = 1
                }
                if Xaxis[1]>201 {
                    Xaxis[1] = 201
                    Xaxis[3] = 201
                }
                
            case "Y":
                for i in 0 ... 373 {
                    elimX(array1: data,array2: &arrayY, x: X);
                    elimY(array1: arrayY, array2: &arrayMach, g: y, y: y[0]+deltaY*Float(i));
                    elimMach(array1: arrayMach, array2: &arrayBeta, g: mach, mach: Mach);
                    elimBeta(array1: arrayBeta, array2: &arrayAlpha, g: beta, beta: Beta);
                    elimAlpha(array1: arrayAlpha, answer: &answer, g: alpha, alpha: Alpha);
                    plotArray[i]=answer
                }
                Yaxis[0] = 1 ; Yaxis[1] = 1 ; Yaxis[2] = 1 ; Yaxis[3] = 201
                label3.text = "0"
                label4.text = "11"
                for i in 0 ... 373 {
                    positivePlotArray[i] = plotArray[i]+(-min(a: plotArray))
                }
                print("min = \(min(a: positivePlotArray))")
                print("max = \(max(a: positivePlotArray))")
                var scale: Float
                if max(a: positivePlotArray) == 0 {
                    scale = 1
                } else {
                    scale = (200/max(a: positivePlotArray))
                }
                scale.round(.down)
                print("scale = \(scale)")
                
                for i in 1 ... 374 {
                    integerPositivePlotArray[i-1] = positivePlotArray[i-1]*scale
                    integerPositivePlotArray[i-1].round(.down)
                    points[i-1]=[i,201-Int(integerPositivePlotArray[i-1]+1)]
                }
                
                var Xcoordinate: Float = scale*(-min(a: plotArray))
                Xcoordinate.round(.down)
                Xaxis[0] = 1 ; Xaxis[1] = 201 - Int(Xcoordinate) ; Xaxis[2] = 374;  Xaxis[3] = 201 - Int(Xcoordinate)
                print(Xaxis[1])
                if Xaxis[1]<=2 {
                    Xaxis[1] = 1
                    Xaxis[3] = 1
                }
                if Xaxis[1]>201 {
                    Xaxis[1] = 201
                    Xaxis[3] = 201
                }
                
            case "X":
                for i in 0 ... 373 {
                    elimX(array1: data,array2: &arrayY, x: x[0]+deltaX*Float(i));
                    elimY(array1: arrayY, array2: &arrayMach, g: y, y: Y);
                    elimMach(array1: arrayMach, array2: &arrayBeta, g: mach, mach: Mach);
                    elimBeta(array1: arrayBeta, array2: &arrayAlpha, g: beta, beta: Beta);
                    elimAlpha(array1: arrayAlpha, answer: &answer, g: alpha, alpha: Alpha);
                    plotArray[i]=answer
                }
                Yaxis[0] = 187 ; Yaxis[1] = 1 ; Yaxis[2] = 187 ; Yaxis[3] = 201
                label3.text = "-4"
                label4.text = "4"
                for i in 0 ... 373 {
                    positivePlotArray[i] = plotArray[i]+(-min(a: plotArray))
                }
                print("min = \(min(a: positivePlotArray))")
                print("max = \(max(a: positivePlotArray))")
                var scale: Float
                if max(a: positivePlotArray) == 0 {
                    scale = 1
                } else {
                    scale = (200/max(a: positivePlotArray))
                }
                scale.round(.down)
                print("scale = \(scale)")
                
                for i in 1 ... 374 {
                    integerPositivePlotArray[i-1] = positivePlotArray[i-1]*scale
                    integerPositivePlotArray[i-1].round(.down)
                    points[i-1]=[i,201-Int(integerPositivePlotArray[i-1]+1)]
                }
                
                var Xcoordinate: Float = scale*(-min(a: plotArray))
                Xcoordinate.round(.down)
                Xaxis[0] = 1 ; Xaxis[1] = 201 - Int(Xcoordinate) ; Xaxis[2] = 374;  Xaxis[3] = 201 - Int(Xcoordinate)
                if Xaxis[1]<=2 {
                    Xaxis[1] = 1
                    Xaxis[3] = 1
                }
                if Xaxis[1]>201 {
                    Xaxis[1] = 201
                    Xaxis[3] = 201
                }
                
            default:
                print("ERROR")
            }
        }
        
        
    
        let myView = Draw(frame: CGRect(x: 20, y: 460, width: 374, height: 201), data: points, Xaxis: Xaxis, Yaxis: Yaxis)
        myView.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        view.addSubview(myView)
        print(choice)
    }
    
    
    
    
    
    
    
    
    //If you press anywhere else, removes all the extra UI (keyboard, droplist, etc.)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    


}



extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vars.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vars[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedVar = vars[row]
        textField6.text = vars[row]
        choice = vars[row]
    }
    
}

