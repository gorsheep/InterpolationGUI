//
//  ViewController.swift
//  InterpolationGUI
//
//  Created by Даниил Волошин on 7/11/18.
//  Copyright © 2018 Даниил Волошин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Declaration of labels
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    
    //Declaration of text boxes
    @IBOutlet var textField1: UITextField!
    @IBOutlet var textField2: UITextField!
    @IBOutlet var textField3: UITextField!
    @IBOutlet var textField4: UITextField!
    @IBOutlet var textField5: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func button1Pressed(_ sender: Any) {
        self.textField1.resignFirstResponder()
        self.textField2.resignFirstResponder()
        self.textField3.resignFirstResponder()
        self.textField4.resignFirstResponder()
        self.textField5.resignFirstResponder()
        label2.text = "x = \(textField5.text ?? "")"
    }
    
    
    //If you press anywhere else, removes all the extra UI (keyboard, droplist, etc.)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    


}

