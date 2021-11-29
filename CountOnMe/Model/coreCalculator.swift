//
//  coreCalculator.swift
//  CountOnMe
//
//  Created by Clément Garcia on 26/11/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class coreCalculator {
    
    // MARK: - Var
    // Calcul done by the model
    var calculText: String = "" {
        didSet {
            delegate?.receiveResult(calculText)
        }
    }
    
    weak var delegate: CalculatorDelegate?
    
    //Items making calcul ("4 + 5" (3 items))
    var elements: [String] {
        return calculText.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables - Does the current calcul ends by + or - ?
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    // Does calcul expression have at least 3 items
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    // Can an operation (+/-) be added at the end of the current calcul expression ? Does the current calcul finish with +/- already ?
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    // Did the calcul expression provide a result ?
    var expressionHaveResult: Bool {
        return calculText.firstIndex(of: "=") != nil
    }
    
    // MARK: - Functions
    
    //Func to add a number to current calcul. If the calcul does have a result already, clearing calcul expression
    func addNumberToCalcul(_ number: String){
        if expressionHaveResult {
            calculText = ""
        }
        calculText.append(number)
    }
    
    //Func to add operator to calcul expression
    func addOperator(_ operatorCalcul: String) {
        if !canAddOperator {
            delegate?.receiveAlert("Operator error", "The operator \(operatorCalcul) can't be added here")
            return
        }
        
        if expressionHaveResult {
            calculText = elements.last!
        }
        
        calculText.append(" \(operatorCalcul) ")
    }
    
    //Func to provide result
    func calculResult() {
        if !expressionIsCorrect {
            delegate?.receiveAlert("Result error", "The calcul expression is invalide. Please make sure to enter a valid calcul.")
            return
        }
        
        if !expressionHaveEnoughElement {
            delegate?.receiveAlert("Result error", "There is not enough element to make a calcul.")
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        calculText.append(" = \(operationsToReduce.first!)")
        
    }
}
