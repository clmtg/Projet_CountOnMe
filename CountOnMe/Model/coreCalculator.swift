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
    
    //Use to link the model and the view
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
    
    // Does calcul expression have at least 3 items
    var expressionHasResult: Bool {
        return calculText.contains("=")
    }
    
    // Can an operation (+/-) be added at the end of the current calcul expression ? Does the current calcul finish with +/- already ?
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "÷"
    }
    
    // Did the calcul expression provide a result ?
    var expressionHaveResult: Bool {
        return calculText.firstIndex(of: "=") != nil
    }
    
    // MARK: - Functions
    
    //Func to add a number to current calcul. If the calcul does have a result already, clearing calcul expression
    func addNumberToCalcul(_ number: String){
        if expressionHaveResult {
            resetCalcul()
        }
        
        if calculText == "0" {
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
        
        if expressionHasResult {
            delegate?.receiveAlert("Result error", "A result has been provided already")
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            
            let result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "x": result = left * right
            case "÷":
                if right == 0 {
                    delegate?.receiveAlert("Calcul error", "Can not process a division by zero.")
                    return
                }
                else {
                    result = left / right
                }
            default: fatalError("Unknown operator !")
            }
            

            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(resultIntDoubleCheck.string(from: NSNumber(value: result))!)", at: 0)
            
        }
        
        calculText.append(" = \(operationsToReduce.first!)")
        
    }
    
    func resetCalcul(){
        calculText = "0"
    }
    
    //Function to convert number to correct format ("2 + 2 = 4" -> Correct. "2 + 2 = 4.0" -> Wrong. )
    private var resultIntDoubleCheck: NumberFormatter = {
        let numberConvertor = NumberFormatter()
        numberConvertor.minimumIntegerDigits = 1
        numberConvertor.maximumFractionDigits = 2
        return numberConvertor
    }()
}
