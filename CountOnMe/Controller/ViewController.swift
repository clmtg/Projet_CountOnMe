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
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        core.addNumberToCalcul(sender.title(for: .normal)!)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        core.addOperator(sender.title(for: .normal)!)
        
        /*
        
        else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
        
        
        */
        
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        core.addOperator(sender.title(for: .normal)!)
        
        /* else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
         
         */
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        /*
        guard expressionIsCorrect else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        guard expressionHaveEnoughElement else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        */
        
        core.calculResult()
    }

}

// MARK: - Extensions and Protocols

//ViewController MUST respect calculatorDelegate protocol (function listed in protocol MUST be implemented into ViewController)

// Are protocols classes ? Therefore can be used as extensions

extension ViewController:calculatorDelegate {
    func receiveAlert(_ coreAlert: String) {
    }
    
    func receiveResult(_ coreResult: String) {
        textView.text = coreResult
    }
}
