//
//  ExpenseListViewController.swift
//  CouchTracker
//
//  Created by Heiko Dreyer on 03/12/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

import UIKit

class ExpenseListViewController: UITableViewController, CBLUITableDelegate {
    private var _tableViewSource: CBLUITableSource!
    var database: CBLDatabase!
    var query: CBLQuery!
    
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
    
    lazy var currencyFormatter: NSNumberFormatter = {
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        return currencyFormatter
    }()
    
    // MARK: - View related
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.registerClass(ExpenseItemViewCellTableViewCell.self, forCellReuseIdentifier: "Cell")
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertExpense:")
        self.navigationItem.rightBarButtonItem = addButton
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Data
    
    func loadData() {
        _tableViewSource = CBLUITableSource()
        _tableViewSource.tableView = tableView
        tableView.dataSource = _tableViewSource
        let view = database.viewNamed("ExpensesByDate")
        
        // This is our map/reduce code
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                    emit(doc["createdAt"], doc)
                }, reduceBlock: { (keys, values, rereduce) in
                    var total: Double = 0.0
                    let sValues = values as! [NSDictionary];
                    for value in sValues {
                        if let sValue = value["amount"] as? Double {
                            total += sValue
                        }
                    }
                    return total
                }, version: "10")
        }
        
        query = view.createQuery()
        let liveQuery = query.asLiveQuery()
        let dataSource = tableView.dataSource as? CBLUITableSource
        liveQuery.descending = true
        liveQuery.mapOnly = true
        dataSource?.query = liveQuery
    }
    
    func insertNewDocument(title: String, amount: String, createdAt: NSDate) {
        let expense = Expense(newDocumentInDatabase: database)
        expense.title = title
        expense.amount = numberFormatter.numberFromString(amount)
        expense.createdAt = createdAt
        
        var error: NSError? = nil
        if(!expense.save(&error)) {
            print("There was an error saving the object: " + error!.description)
        }
    }
    
    func allTimeAmount() -> Double {
        if self.query != nil {
            let enumerator = self.query.run(nil)
            if enumerator.count > 0 {
                return enumerator.rowAtIndex(0).value as! Double
            }
        }
        
        return 0.0
    }
    
    // MARK: - Action
    
    func insertExpense(sender: AnyObject) {
        weak var wSelf = self
        let alertController = UIAlertController(title: "Add Expense", message: "Add a new expense", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { action in
            if let sSelf = wSelf {
                let titleTextfield: UITextField = alertController.textFields![0] as! UITextField
                let amountTextfield: UITextField = alertController.textFields![1] as! UITextField
                sSelf.insertNewDocument(titleTextfield.text, amount: amountTextfield.text, createdAt: NSDate())
            }
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
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                if let textfield: UITextField = notification.object as! UITextField! {
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
            header.amountLabel.text = currencyFormatter.stringFromNumber(allTimeAmount())!;
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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func couchTableSource(source: CBLUITableSource!, updateFromQuery query: CBLLiveQuery!, previousRows: [AnyObject]!) {
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    // MARK: - Table View (Couchbase related)
    
    func couchTableSource(source: CBLUITableSource!, deleteRow row: CBLQueryRow!) -> Bool {
        if let document = row.document {
            if let expense = Expense(forDocument: document) {
                return expense.deleteDocument(nil)
            }
        }
        
        return false
    }
    
    func couchTableSource(source: CBLUITableSource!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ExpenseItemViewCellTableViewCell
        let formatter = NSDateFormatter();
        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let document: CBLDocument = source.documentAtIndexPath(indexPath)
        let model: Expense? = Expense(forDocument: document)
        cell.titleLabel.text = model?.title
        cell.setColor(AppDelegate.Colors.Green)
        
        if let amount = model?.amount {
            cell.amountLabel.text = currencyFormatter.stringFromNumber(amount)!
        }
        
        if let date = model?.createdAt {
            cell.dateLabel.text = formatter.stringFromDate(date)
        }
        
        return cell
    }
}
