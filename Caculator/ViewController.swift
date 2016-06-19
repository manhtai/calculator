//
//  ViewController.swift
//  Caculator
//
//  Created by Manh Tai on 6/19/16.
//  Copyright © 2016 Manh Tai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let currentTextInDisplay = display.text!
            display.text = currentTextInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }


    @IBAction func performOperation(sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        if let mathematicSymbol = sender.currentTitle {
            if mathematicSymbol == "π" {
                 display.text = String(M_PI)
            }
        }
    }
}

