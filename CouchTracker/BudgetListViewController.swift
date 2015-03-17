//
//  BudgetListViewController.swift
//  CouchTracker
//
//  Created by Heiko Dreyer on 03/12/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

import UIKit

class BudgetListViewController: UITableViewController {
    var database: CBLDatabase!
    var manager: CBLManager!
    
    var objects = [AnyObject]()
    
    lazy var backgroundView: UIView = {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "Avenir-Light", size: 15)
        label.textColor = UIColor(red: 0.631, green: 0.651, blue: 0.678, alpha: 1)
        label.text = NSLocalizedString("No expense yet", comment: "No expense yet.")
        label.textAlignment = .Center
        return label
    }()
    
    lazy var numberFormatter: NSNumberFormatter = {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.locale = NSLocale.currentLocale();
        numberFormatter.numberStyle = .DecimalStyle
        return numberFormatter
    }()
    
    // MARK: - View related
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.registerClass(ExpenseItemViewCellTableViewCell.self, forCellReuseIdentifier: "Cell")
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertExpense:")
        self.navigationItem.rightBarButtonItem = addButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
    }
    
    // MARK: - Action
    
    func insertExpense(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Expense", message: "Add a new expense", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { action in
            let titleTextfield: UITextField = alertController.textFields![0] as UITextField
            let amountTextfield: UITextField = alertController.textFields![1] as UITextField
            
            print(titleTextfield.text + " : " + amountTextfield.text)
            
            // TODO: implement shit
        }
        okAction.enabled = false
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { _ in }
        alertController.addAction(cancelAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Title"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
            
            weak var wSelf = self
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                if let textfield: UITextField = notification.object as UITextField! {
                    okAction.enabled = (textfield.text != nil && (wSelf!.numberFormatter.numberFromString(textfield.text)) != nil)
                }
                
            }
        }
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: - Table View
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = ExpenseHeaderView(frame: CGRectZero)
            header.setColor(AppDelegate.Colors.Green)
            return header
        }
        
        return nil
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66;
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objects.count == 0 {
            tableView.backgroundView = backgroundView
            backgroundView.frame = tableView.frame
        } else {
            tableView.backgroundView = nil
        }
        
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as ExpenseItemViewCellTableViewCell
        let formatter = NSDateFormatter();
        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let object = objects[indexPath.row] as NSDate
        cell.titleLabel.text = object.description
        cell.dateLabel.text = formatter.stringFromDate(object)
        cell.amountLabel.text = "23512 $"
        cell.setColor(AppDelegate.Colors.Green)
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

