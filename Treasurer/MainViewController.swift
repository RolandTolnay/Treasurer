//
//  MainViewController.swift
//  Treasurer
//
//  Created by Roland Tolnay on 30/11/15.
//  Copyright © 2015 Roland Tolnay. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var newPurchaseButton: UIButton!
    
    let account = Account.sharedInstance
    let dateFormatter = NSDateFormatter()
    
    //MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedAccount = Account.loadAccount() {
            account.totalMoney = savedAccount.totalMoney
        }
        dateFormatter.dateFormat = "MMM-dd"
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        historyTableView.layer.masksToBounds = true
        historyTableView.layer.borderColor = UIColor.blueColor().CGColor
        historyTableView.layer.borderWidth = 2.0
        
        updateValuesForAccount()
    }
    
    func updateValuesForAccount() {
        let totalMoneyLabelText = "Total: " + String(format:"%.2f", account.totalMoney) + " DKK"
        totalMoneyLabel.text = totalMoneyLabelText
        saveAccount()
    }
    
    //MARK: Deposit popover
    
    @IBAction func showDepositPopover(sender: UITapGestureRecognizer) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popoverContent = storyboard.instantiateViewControllerWithIdentifier("depositPopover")
        popoverContent.preferredContentSize = CGSizeMake(400, 100)
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover: UIPopoverPresentationController = popoverContent.popoverPresentationController!
        popover.delegate = self;
        popover.permittedArrowDirections = [ .Up, .Left ]
        popover.sourceView = self.view;
        popover.sourceRect = totalMoneyLabel.frame;
        presentViewController(popoverContent, animated: true, completion:nil)
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        print("Popover was dismissed")
        updateValuesForAccount()
        historyTableView.reloadData()
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    //MARK: Purchase popover
    
    @IBAction func showPurchasePopover(sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popoverContent = storyboard.instantiateViewControllerWithIdentifier("purchasePopover")
        popoverContent.preferredContentSize = CGSizeMake(400, 400)
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover: UIPopoverPresentationController = popoverContent.popoverPresentationController!
        popover.delegate = self;
        popover.sourceView = self.view;
        popover.sourceRect = newPurchaseButton.frame;
        presentViewController(popoverContent, animated: true, completion:nil)
    }
    
    
    //MARK: Tableview
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return account.history.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "historyItemCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HistoryItemTableViewCell
        
        let historyItem = account.history[indexPath.row]
        
        let date = dateFormatter.stringFromDate(historyItem.date)
        cell.dateLabel.text = date
        
        if let deposit = historyItem as? Deposit {
            cell.descriptionLabel.text = deposit.message
            cell.numberOfItemsLabel.hidden = true
            cell.priceLabel.text = "+" + String(format:"%.2f", deposit.amount)
            cell.priceLabel.textColor = UIColor.greenColor()
        }
        if let purchase = historyItem as? Purchase {
            cell.descriptionLabel.text = purchase.itemName
            cell.numberOfItemsLabel.hidden = false
            cell.numberOfItemsLabel.text = String(purchase.numberOfItems)
            cell.priceLabel.text = "-" + String(format:"%.2f", purchase.price)
            cell.priceLabel.textColor = UIColor.redColor()
        }
        
        return cell
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let historyItem = account.history.removeAtIndex(indexPath.row) 
            
            if let deposit = historyItem as? Deposit {
               account.totalMoney -= deposit.amount
            }
            if let purchase = historyItem as? Purchase {
                account.totalMoney += purchase.price
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            updateValuesForAccount()
            account.saveHistory()
        }
    }

    
    //MARK: NSCoding

   func saveAccount(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(account, toFile: Account.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save account")
        }
    }
    

    
}

