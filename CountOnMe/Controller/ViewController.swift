//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    var core = coreCalculator()
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!

    // MARK: View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        core.delegate = self
        core.resetCalcul()
    }
    
    // MARK: - IBAction
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        core.addNumberToCalcul(sender.title(for: .normal)!)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        core.addOperator(sender.title(for: .normal)!)
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        core.addOperator(sender.title(for: .normal)!)
    }
    
    @IBAction func tappedMultiplicationButtonButton(_ sender: UIButton) {
        core.addOperator(sender.title(for: .normal)!)
    }
    
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        core.addOperator(sender.title(for: .normal)!)
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        core.calculResult()
    }
    
    @IBAction func tappedACButton(_ sender: UIButton) {
        core.resetCalcul()
    }
}

// MARK: - Extensions and Protocols
extension ViewController: CalculatorDelegate {
    
    func receiveAlert(_ coreAlertTitle: String, _ coreAlertText: String) {
        let alertVC = UIAlertController(title: coreAlertTitle, message: coreAlertText, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
    
    func receiveResult(_ coreResult: String) {
        textView.text = coreResult
    }
}
