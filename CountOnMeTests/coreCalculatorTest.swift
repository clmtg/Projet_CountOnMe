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
    
    // MARK: - Tests for AddingNumber
    
    func testGivenCalculExpressionisEmpty_WhenAddingNumberToCalcul_ThenCalculIsNotEmpty(){
        calculator.calculText = ""
        calculator.addNumberToCalcul("5")
        XCTAssert(calculator.calculText != "")
        XCTAssert(calculator.elements.count == 1)
    }
    
    func testGivenCalculHasNumberOnly_WhenAddingNumberToCalcul_ThenNewNumberIsAppendedOnly(){
        calculator.calculText = "5"
        calculator.addNumberToCalcul("6")
        XCTAssert(calculator.calculText == "56")
    }
    
    func testGivenCalculHasNumberAndOperator_WhenAddingNumberToCalcul_ThenNewNumberIsAppendedToLast(){
        calculator.calculText = "5 + 6"
        calculator.addNumberToCalcul("7")
        XCTAssert(calculator.calculText == "5 + 67")
    }
    
    func testGivenCalculHasNumberAndOperatorAndResult_WhenAddingNumberToCalcul_ThenCalculIsNewNumberOnly(){
        calculator.calculText = "5 + 6 = 11"
        calculator.addNumberToCalcul("7")
        XCTAssert(calculator.calculText == "7")
    }
    
    
    // MARK: - Tests for AddingOperator
    
    func testGivenCalculHasNoNumber_WhenAddingOperator_ThenOperatorIsAppendedOnly(){
        calculator.calculText = ""
        calculator.addOperator("-")
        XCTAssert(calculator.calculText == " - ")
    }
    
    func testGivenCalculHasNumberOnly_WhenAddingOperator_ThenOperatorIsAppendedOnly(){
        calculator.calculText = "5"
        calculator.addOperator("-")
        XCTAssert(calculator.calculText == "5 - ")
    }
    
    func testGivenCalculFinishesWithOperator_WhenAddingOperator_ThenOperatorIsNotAdded(){
        calculator.calculText = "5 - "
        calculator.addOperator("-")
        XCTAssert(calculator.calculText == "5 - ")
    }
    
    func testPreviousResultIsAvailable_WhenAddingOperator_ThenCalculHasPreviousResultAndOpertor(){
        calculator.calculText = "2 + 2 = 4"
        calculator.addOperator("-")
        XCTAssert(calculator.calculText == "4 - ")
    }
    
    // MARK: - Tests for calculResult
    
    func testGivenCalculIsEmpty_WhenResultIsRequested_ThenResultIsZero(){
        calculator.calculText = ""
        calculator.calculResult()
        XCTAssert(calculator.calculText == "")
    }
    
    func testGivenElementsCountsIsNotEnough_WhenResultIsRequested_ThenResultIsNotProcessed(){
        calculator.calculText = "2 + "
        calculator.calculResult()
        XCTAssert(calculator.calculText == "2 + ")
    }
    
    func testGivenCalculIsValidAddition_WhenResultIsRequested_ThenResultIsCorrect(){
        calculator.calculText = "2 + 2"
        calculator.calculResult()
        XCTAssert(calculator.calculText == "2 + 2 = 4")
    }
    
    func testGivenCalculIsValidSubstraction_WhenResultIsRequested_ThenResultIsCorrect(){
        calculator.calculText = "4 - 2"
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 - 2 = 2")
    }
    
    // MARK: - Tests related to division
    func testGivenElementOneIsGreaterThanElementTwo_WhenDivision_ThenResultIsCorrect(){
        calculator.calculText = "8 ÷ 2"
        calculator.calculResult()
        XCTAssert(calculator.calculText == "8 ÷ 2 = 4")
    }
    
    func testGivenElementTwoIsGreaterThanElementOne_WhenDivision_ThenResultIsCorrect(){
        calculator.calculText = "4 ÷ 8"
        calculator.calculResult()
        XCTAssert(calculator.calculText == "4 ÷ 8 = 0.5")
    }
    
}
