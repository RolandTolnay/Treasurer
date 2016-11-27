//
//  PurchaseViewController.swift
//  Treasurer
//
//  Created by Roland Tolnay on 02/12/15.
//  Copyright © 2015 Roland Tolnay. All rights reserved.
//

import UIKit

struct Item {
    var name: String
    var price: Double?
}

class PurchaseViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: Properties
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var itemNameTableView: UITableView!
    @IBOutlet weak var numberOfItemsTextField: UITextField!
    @IBOutlet weak var numberOfItemsStepper: UIStepper!
    @IBOutlet weak var totalPriceTextField: UITextField!
    var dateTextField: UITextField!
    
    let account = Account.sharedInstance
    let dateFormatter = NSDateFormatter()
    
    var purchaseDate = NSDate()
    var items = [Item]()
    
    //MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        
        numberOfItemsStepper.wraps = true
        numberOfItemsStepper.autorepeat = true
        numberOfItemsStepper.maximumValue = 99
        numberOfItemsStepper.minimumValue = 1
        numberOfItemsStepper.value = 1.0
        
        numberOfItemsTextField.delegate = self
        itemNameTableView.delegate = self
        itemNameTableView.dataSource = self
    }
    
    func initData() {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateText = dateFormatter.stringFromDate(purchaseDate)
        dateButton.setTitle(dateText, forState: .Normal)
        
        items = loadItems()
    }
    
    func loadItems() -> [Item] {
        var localItems = [Item]()
        
        for historyItem in account.history {
            if let purchase = historyItem as? Purchase {
                var inArray = false
                for item in localItems {
                    if item.name == purchase.itemName {
                        inArray = true
                        break;
                    }
                }
                if !inArray {
                    let itemPrice = purchase.price / Double(purchase.numberOfItems)
                    let newItem = Item(name: purchase.itemName, price: itemPrice)
                    localItems.append(newItem)
                }
            }
        }
        
        return localItems
    }
    
    
    //MARK: Text field delegate and input validation
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField === dateTextField) {
            if let validDate = dateFormatter.dateFromString(textField.text!) {
                purchaseDate = validDate
                let dateText = dateFormatter.stringFromDate(purchaseDate)
                dateButton.setTitle(dateText, forState: .Normal)
                
                dateTextField.hidden = true
                dateButton.hidden = false
            }
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if (textField === numberOfItemsTextField) {
            if let value = Double(numberOfItemsTextField.text!) {
                if let purchasePrice = Double(totalPriceTextField.text!) {
                    
                    let perItemPrice = purchasePrice / numberOfItemsStepper.value
                    totalPriceTextField.text = (perItemPrice * value).description
                }
                numberOfItemsStepper.value = value
               
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    @IBAction func numberOfItemsChangedByStepper(sender: UIStepper) {
        if let purchasePrice = Double(totalPriceTextField.text!), numberOfItems = Double(numberOfItemsTextField.text!) {
            
            let perItemPrice = purchasePrice / numberOfItems
            totalPriceTextField.text = (perItemPrice * numberOfItemsStepper.value).description
        }
        numberOfItemsTextField.text = Int(numberOfItemsStepper.value).description
    }
    
    //MARK: Tableview delegate and datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "purchaseItemCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PurchaseItemTableViewCell
        let item = items[indexPath.row]
        
        cell.itemNameLabel.text = item.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PurchaseItemTableViewCell
        
        itemTextField.text = cell.itemNameLabel.text
        let selectedItem = items[indexPath.row]
        totalPriceTextField.text = selectedItem.price?.description
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recently used"
    }
    
    //MARK: Actions
    
    @IBAction func changeDate(sender: UIButton) {
        //Hide the triggering button
        dateButton.hidden = true
        
        if dateTextField != nil {
            dateTextField.hidden = false
            dateTextField.text = ""
            dateTextField.becomeFirstResponder()
        } else {
            //Create date input
            dateTextField = UITextField(frame: CGRectMake(116, 7, 200, 30))
            dateTextField.placeholder = "dd-MM-yyyy"
            dateTextField.font = UIFont.systemFontOfSize(14)
            dateTextField.borderStyle = UITextBorderStyle.RoundedRect
            dateTextField.autocorrectionType = UITextAutocorrectionType.No
            dateTextField.keyboardType = UIKeyboardType.Default
            dateTextField.returnKeyType = UIReturnKeyType.Done
            dateTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
            dateTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            dateTextField.delegate = self
            self.view.addSubview(dateTextField)
            dateTextField.becomeFirstResponder()
        }
    }
    
    
    
    @IBAction func createPurchase(sender: UIButton) {
        
        if let itemName = itemTextField.text,
            numberOfItems = Int(numberOfItemsTextField.text!),
            purchasePrice = Double(totalPriceTextField.text!) {
                let newPurchase = Purchase(itemName: itemName, numberOfItems: numberOfItems, price: purchasePrice, date: purchaseDate)
                
                account.history.append(newPurchase)
                account.totalMoney -= purchasePrice
                account.saveHistory()
                
                self.dismissViewControllerAnimated(true, completion: nil)
                self.popoverPresentationController!.delegate!.popoverPresentationControllerDidDismissPopover!(self.popoverPresentationController!)
        }
    }
    
    
}
