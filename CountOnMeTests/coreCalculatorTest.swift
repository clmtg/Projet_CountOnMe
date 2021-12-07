//
//  coreCalculatorTest.swift
//  CountOnMeTests
//
//  Created by Clément Garcia on 29/11/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

/*
 GivenPostHasZeroLike_WhenPostIsLiked_ThenPostHasOneLike
 // ETANT DONNÉ QUE le poste n'a pas de like
 // QUAND le poste est liké
 // ALORS le poste a un like
 */

import XCTest
@testable import CountOnMe

class coreCalculatorTest: XCTestCase {
    
    
    var calculator: coreCalculator!
    
    override func setUp() {
        super.setUp()
        calculator = coreCalculator()
    }
    
    
    private func setCalculExpression(_ calculToSet: String){
        let elements = calculToSet.split(separator: " ").map { "\($0)" }
        let digitsCharacters = CharacterSet.decimalDigits
        
        for item in elements {
            if CharacterSet(charactersIn: item).isSubset(of: digitsCharacters) {
                calculator.addNumberToCalcul(item)
            }
            else {
                calculator.addOperator(item)
            }
        }
    }
    
    // MARK: - Tests for AddingNumber
    
    func testGivenCalculExpressionisEmpty_WhenAddingNumberToCalcul_ThenCalculIsNotEmpty(){
        calculator.addNumberToCalcul("5")
        XCTAssert(calculator.calculText != "")
        XCTAssert(calculator.elements.count == 1)
    }
    
    func testGivenCalculHasNumberOnly_WhenAddingNumberToCalcul_ThenNewNumberIsAppendedOnly(){
        setCalculExpression("5")
        calculator.addNumberToCalcul("6")
        XCTAssert(calculator.calculText == "56")
    }
    
    func testGivenCalculHasNumberAndOperator_WhenAddingNumberToCalcul_ThenNewNumberIsAppendedToLast(){
        calculator.addNumberToCalcul("5")
        calculator.addOperator("+")
        calculator.addNumberToCalcul("6")
        
        calculator.addNumberToCalcul("7")
        XCTAssert(calculator.calculText == "5 + 67")
        
    }
    
    func testGivenCalculHasNumberAndOperatorAndResult_WhenAddingNumberToCalcul_ThenCalculIsNewNumberOnly(){
        setCalculExpression("5 + 6")
        calculator.calculResult()
        
        calculator.addNumberToCalcul("7")
        XCTAssert(calculator.calculText == "7")
    }
    
    func testGivenCalculIsEmpty_WhenAddingNumberToCalcul_ThenCalculIsAddedNumberOnly(){
        calculator.resetCalcul()
        
        calculator.addNumberToCalcul("7")
        XCTAssert(calculator.calculText == "7")
    }
    
    
    // MARK: - Tests for AddingOperator
    
    func testGivenCalculHasNoNumber_WhenAddingOperator_ThenOperatorIsAppendedOnly(){
        calculator.addOperator("-")
        XCTAssert(calculator.calculText == " - ")
    }
    
    func testGivenCalculHasNumberOnly_WhenAddingOperator_ThenOperatorIsAppendedOnly(){
        setCalculExpression("5")
        
        calculator.addOperator("-")
        XCTAssert(calculator.calculText == "5 - ")
    }
    
    func testGivenCalculFinishesWithOperator_WhenAddingOperator_ThenOperatorIsNotAdded(){
        setCalculExpression("5 - ")
        
        calculator.addOperator("-")
        XCTAssert(calculator.calculText == "5 - ")
    }
    
    func testPreviousResultIsAvailable_WhenAddingOperator_ThenCalculHasPreviousResultAndOpertor(){
        setCalculExpression("2 + 2")
        calculator.calculResult()
        
        calculator.addOperator("-")
        XCTAssert(calculator.calculText == "4 - ")
    }
    
    // MARK: - Tests for calculResult
    
    func testGivenCalculIsEmpty_WhenResultIsRequested_ThenResultIsEmpty(){
        calculator.calculResult()
        XCTAssert(calculator.calculText == "")
    }
    
    func testGivenElementsCountsIsNotEnough_WhenResultIsRequested_ThenResultIsNotProcessed(){
        setCalculExpression("2 + ")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "2 + ")
    }
    
    func testGivenCalculIsValidAddition_WhenResultIsRequested_ThenResultIsCorrect(){
        setCalculExpression("2 + 2")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "2 + 2 = 4")
    }
    
    func testGivenCalculIsValidSubstraction_WhenResultIsRequested_ThenResultIsCorrect(){
        setCalculExpression("4 - 2")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 - 2 = 2")
    }
    
    func testGivenCalculHasResultAlready_WhenResultIsRequested_ResultIsNotProcessedOnceAgain(){
        setCalculExpression("4 - 2")
        calculator.calculResult()
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 - 2 = 2")
    }
    
    func testGivenCalculWithSeveralAddition_WhenResultIsRequested_ResultIsCorrect(){
    }
    
    // MARK: - Tests related to division
    func testGivenElementOneIsGreaterThanElementTwo_WhenDivision_ThenResultIsCorrect(){
        setCalculExpression("8 ÷ 2")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "8 ÷ 2 = 4")
    }
    
    func testGivenElementTwoIsGreaterThanElementOne_WhenDivision_ThenResultIsCorrect(){
        setCalculExpression("4 ÷ 8")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 ÷ 8 = 0.5")
    }
    
    func testGivenElementTwoIsZero_WhenDivision_ThenResultIsNotProcesses(){
        setCalculExpression("4 ÷ 0")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 ÷ 0")
    }
    
    
    // MARK: - Tests related to multiplication
    
    func testGivenCalculIsValidWithTwoItems_WhenMultiplication_ThenResultIsCorrect(){
        setCalculExpression("4 x 2")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 x 2 = 8")
    }
    
    func testGivenCalculIsEmpty_WhenStartedWithMultiplicationAndProcess_ThenResultIsCorrect(){
        setCalculExpression("0")
        
        calculator.addOperator("x")
        calculator.addNumberToCalcul("2")
        calculator.calculResult()
        XCTAssert(calculator.calculText == "1 x 2 = 2")
    }
    
    func testGivenCalculIsEmpty_WhenStartedWithDivisionAndProcess_ThenResultIsCorrect(){
        setCalculExpression("0")
        
        calculator.addOperator("÷")
        calculator.addNumberToCalcul("2")
        calculator.calculResult()
        XCTAssert(calculator.calculText == "1 ÷ 2 = 0.5")
    }
    
    // MARK: - Tests related to calcul reset
    
    func testGivenCalculIsNotEmpty_WhenDividPerZero_CalculIsNotProcessed(){
        setCalculExpression("4 ÷ 0")
        
        calculator.resetCalcul()
        XCTAssert(calculator.calculText == "0")
    }
    
    // MARK: - Tests related to multiple operator
    
    func testGivenExpressionHasMultipleAdditionOnly_WhenCalculate_CalculProcessed(){
        setCalculExpression("4 + 3 + 2")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 + 3 + 2 = 9")
    }
    
    func testGivenExpressionHasMultipleSubstractionOnly_WhenCalculate_CalculProcessed(){
        setCalculExpression("4 - 3 - 2")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 - 3 - 2 = -1")
    }
    
    func testGivenExpressionHasMultipleMultiplicateOnly_WhenCalculate_CalculProcessed(){
        setCalculExpression("4 x 3 x 2")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 x 3 x 2 = 24")
    }
    
    func testGivenExpressionHasMultipleDivisionOnly_WhenCalculate_CalculProcessed(){
        setCalculExpression("4 ÷ 3 ÷ 2")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 ÷ 3 ÷ 2 = 0.66")
    }
    
    func testGivenExpressionHasAdditionAndMultiplication_WhenCalculate_CalculProcessed(){
        setCalculExpression("4 + 3 x 2")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText != "4 + 3 x 2 = 14")
        XCTAssert(calculator.calculText == "4 + 3 x 2 = 10")
    }
    
    func testGivenExpressionHasAdditionAndDivision_WhenCalculate_CalculProcessed(){
        setCalculExpression("4 + 3 ÷ 2")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 + 3 ÷ 2 = 5.5")
    }
    
    func testGivenExpressionHasMultiplicationAndDivision_WhenCalculate_CalculProcessed(){
        setCalculExpression("4 x 3 ÷ 2")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 x 3 ÷ 2 = 6")
    }
    
    func testGivenExpressionHasMultiplicationAndDivisionPerZero_WhenCalculate_CalculProcessed(){
        setCalculExpression("4 x 3 ÷ 0")
        
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 x 3 ÷ 0")
    }
}




