//
//  calculatorDelegate.swift
//  CountOnMe
//
//  Created by Clément Garcia on 29/11/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculatorDelegate: AnyObject {
    func receiveResult(_ coreResult: String)
    func receiveAlert(_ coreAlertTitle: String, _ coreAlertText: String)

}
