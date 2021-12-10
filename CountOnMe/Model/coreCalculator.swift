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

    /// Calcul expression done by the model
    var calculText: String = "" {
        didSet {
            delegate?.receiveResult(calculText)
        }
    }
    
    /// Used to link controller and model
    weak var delegate: CalculatorDelegate?
    
    /// Array elements making calcul expression. E.g. : "5 + 6" 3 elements ("5" "+" "6")
    var elements: [String] {
        return calculText.split(separator: " ").map { "\($0)" }
    }
    
    
    /// Flag to check if calcul expression ends with an operator. False means calcul expression is incomplete
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "÷" && elements.last?.last != "."
    }
    
    /// Flag to check if calcul expression does have at least 2 numbers and 1 operator. True means calcul expression has at least 3 elements
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    /// Flag to check if calcul expression does contain a result already
    var expressionHasResult: Bool {
        return calculText.contains("=")
    }
    
    /// Flag to check if calcul expression does contain a result already
    var lastValueHasDot: Bool {
        if elements.count > 0 {
            return elements.last!.contains(".")
        }
        return false
    }
    
    /// Convertor used to have number to correct format ("2 + 2 = 4" -> Correct. "2 + 2 = 4.0" -> Wrong. )
    private var resultIntDoubleCheck: NumberFormatter = {
        let numberConvertor = NumberFormatter()
        numberConvertor.minimumIntegerDigits = 1
        numberConvertor.maximumFractionDigits = 2
        return numberConvertor
    }()

    /// List of operator used by the coreCalculator
    let operatorList = ["+", "-", "x", "÷"]

    // MARK: - Functions
    
    /// Func to add a number to current calcul. If the calcul does have a result already,  calcul expression is cleared first
    /// - Parameter number: Number to add to the calcul expression
    func addNumberToCalcul(_ number: String){
        
        if expressionHasResult {
            resetCalcul()
        }
        
        if calculText == "0" && number != "."{
            calculText = ""
        }

        if number == "." {
            if lastValueHasDot {
                delegate?.receiveAlert("Number error", "This number is a decimal number already")
                return
            }
            
            if operatorList.contains(elements.last!){
                addNumberToCalcul("0")
            }
        }
        
        calculText.append(number)
    }
    
    /// Func to add an operator to calcul expression
    /// - Parameter operatorCalcul: Operator to add to the calcul expression
    func addOperator(_ operatorCalcul: String) {
        if !expressionIsCorrect {
            delegate?.receiveAlert("Operator error", "The operator \(operatorCalcul) can't be added here")
            return
        }
        
        if expressionHasResult {
            calculText = elements.last!
        }
        
        if calculText == "0" {
            if operatorCalcul == "x" || operatorCalcul == "÷"  {
                calculText = "1"
            }
        }
        calculText.append(" \(operatorCalcul) ")
    }
    
    /// Func to calcul result from calcul expression input by the user. It does check if the input is correct and if a result has been provided already.
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
            let operatorToProcees = getMostImportantOperatorIndex(operationsToReduce)
            let left = Double(operationsToReduce[operatorToProcees - 1])!
            let operand = operationsToReduce[operatorToProcees]
            let right = Double(operationsToReduce[operatorToProcees + 1])!
            
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
            
            operationsToReduce.remove(at: operatorToProcees+1)
            operationsToReduce.remove(at: operatorToProcees)
            operationsToReduce.remove(at: operatorToProcees-1)
            operationsToReduce.insert("\(resultIntDoubleCheck.string(from: NSNumber(value: result))!)", at: operatorToProcees-1)
        }
        
        calculText.append(" = \(operationsToReduce.first!)")
    }
    
    /// Function to reset calcul expression. This set the calcul expression to "0". Also used when "AC" button is tapped
    func resetCalcul(){
        calculText = "0"
    }
    
    /// Return the index of the most important operator. x and ÷ are more important than + and -. If there aren't "x" or "÷", 1 is returned as it should be the index of the first operator.
    /// - Parameter expression: Array of elements making the calcul expression. E.g. : "5 + 6" 3 elements ("5" "+" "6")
    /// - Returns: The operator index that must be handled first. (x or ÷). Otherwise returns 1
    private func getMostImportantOperatorIndex(_ expression: [String]) -> Int {
        
        var indexMulti = 999999
        var indexDivision = 999999
        
        if expression.contains("x") {
            indexMulti = expression.firstIndex(of: "x")!
        }
        
        if expression.contains("÷") {
            indexDivision = expression.firstIndex(of: "÷")!
        }
        
        if indexMulti == indexDivision {
            return 1
        }
        return min(indexMulti, indexDivision)
    }
}
