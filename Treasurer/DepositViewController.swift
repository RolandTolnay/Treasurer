//
//  DepositViewController.swift
//  Treasurer
//
//  Created by Roland Tolnay on 01/12/15.
//  Copyright © 2015 Roland Tolnay. All rights reserved.
//

import UIKit

class DepositViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func deposit(sender: UIButton) {
        let message = messageTextField.text ?? "Deposit"
        let date = NSDate()
        
        if let amount = Double(amountTextField.text!) {
            let account = Account.sharedInstance
            
            account.history.append(Deposit(message: message, amount: amount, date: date))
            account.totalMoney += amount
            account.saveHistory()
            
            self.dismissViewControllerAnimated(true, completion: nil)
            self.popoverPresentationController!.delegate!.popoverPresentationControllerDidDismissPopover!(self.popoverPresentationController!)
        }
    }
    
}
