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
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "−": Operation.BinaryOperation({ $0 - $1 }),
        "÷": Operation.BinaryOperation({ $0 + $1 }),
        "=": Operation.Equals,
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let val):
                accumulator = val
            case .UnaryOperation(let fun):
                accumulator = fun(accumulator)
            case .BinaryOperation(let fun):
                executePedingOperation()
                pending = PendingOperationInfo(binaryFunction: fun, firstOperand: accumulator)
            case .Equals:
                executePedingOperation()
            }
        }
    }
    
    private func executePedingOperation()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
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
}