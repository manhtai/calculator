//
//  CaculatorBrain.swift
//  Caculator
//
//  Created by Manh Tai on 7/24/16.
//  Copyright © 2016 Manh Tai. All rights reserved.
//

import Foundation


class CalculatorBrain
{
    
    private var accumulator = 0.0
    private var description = ""
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "tan": Operation.UnaryOperation(tan),
        "log": Operation.UnaryOperation(log10),
        "ln": Operation.UnaryOperation(log),
        "%": Operation.UnaryOperation({ $0 * 100.0 }),
        "x²": Operation.UnaryOperation({ $0 * $0 }),
        "+/-": Operation.UnaryOperation({ -$0 }),
        
        
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "−": Operation.BinaryOperation({ $0 - $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "^": Operation.BinaryOperation({ pow($0, $1) }),
        
        
        "=": Operation.Equals,
        "C": Operation.Clear
        
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
    }
    
    func addDesp(text: String) {
        description += text
    }
    
    func clearDesp() {
        description = ""
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            addDesp(symbol)
            switch operation {
            case .Constant(let val):
                accumulator = val
            case .UnaryOperation(let fun):
                accumulator = fun(accumulator)
            case .BinaryOperation(let fun):
                executePendingOperation()
                pending = PendingOperationInfo(
                    binaryFunction: fun,
                    firstOperand: accumulator
                )
            case .Equals:
                executePendingOperation()
            case .Clear:
                accumulator = 0.0
                clearDesp()
            }
        }
    }
    
    private func executePendingOperation()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    var isPartialResult: Bool {
        if pending == nil {
            return false
        }
        return true
    }
    
    
    private var pending: PendingOperationInfo?
    
    private struct PendingOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    var desp: String {
        get {
            var t: String
            if isPartialResult {
                t = description + "..."
            } else {
                if let range = description.rangeOfString("=") {
                    description.removeRange(range)
                    t = description + "="
                } else {
                    t = description
                }
            }
            return t
        }
    }
}