//
//  ViewController.swift
//  Caculator
//
//  Created by Manh Tai on 6/19/16.
//  Copyright © 2016 Manh Tai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet private weak var desp: UILabel!

    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let currentTextInDisplay = display.text!
            if digit == "." && display.text?.rangeOfString(".") != nil {
                return
            }
            if digit == "⬅︎" {
                if currentTextInDisplay.characters.count > 0 {
                    display.text = currentTextInDisplay.substringToIndex((currentTextInDisplay.endIndex.predecessor()))
                }
                return
            }
            display.text = currentTextInDisplay + digit
        } else {
            if digit == "⬅︎" {
                return
            }
            display.text = digit
            if brain.isPartialResult {
                desp.text = brain.desp
            } else {
                brain.clearDesp()
            }
        }
        userIsInTheMiddleOfTyping = true
    }
    
    let sixDecimalFormatter = NSNumberFormatter()
    
    private var displayValue: Double? {

        get {
            return Double(display.text!)
        }
        set {
            sixDecimalFormatter.numberStyle = .DecimalStyle
            sixDecimalFormatter.maximumFractionDigits = 6
            
            if newValue == nil {
                display.text = ""
            }
            display.text = sixDecimalFormatter.stringFromNumber(newValue!)
        }
    }
    
    private var brain = CalculatorBrain()

    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            brain.addDesp(display.text!)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicSymbol = sender.currentTitle {
            brain.performOperation(mathematicSymbol)
            desp.text = brain.desp
        }
        displayValue = brain.result
    }
}

