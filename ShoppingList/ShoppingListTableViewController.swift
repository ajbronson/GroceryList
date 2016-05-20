//
//  ShoppingListTableViewController.swift
//  ShoppingList
//
//  Created by AJ Bronson on 5/20/16.
//  Copyright © 2016 PrecisionCodes. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var nameTextField = UITextField()
    var categoryTextField = UITextField()
    var numberTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ShoppingListController.sharedInstance.fetchResultsController.delegate = self
        setupPickers()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = ShoppingListController.sharedInstance.fetchResultsController.sections else { return "" }
        let index = sections[section].name
        if index == "Macey's" {
            return "Macey's"
        } else if index == "Costco" {
            return "Costco"
        } else if index == "Sams Club" {
            return "Sams Club"
        } else {
            return "Unidentified"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ShoppingListController.sharedInstance.fetchResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = ShoppingListController.sharedInstance.fetchResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("shoppingCell", forIndexPath: indexPath)
        guard let shoppingItem = ShoppingListController.sharedInstance.fetchResultsController.objectAtIndexPath(indexPath) as? ShoppingList, count = shoppingItem.itemCount else { return UITableViewCell() }
        cell.textLabel?.text = shoppingItem.name
        cell.detailTextLabel?.text = "Total to grab: \(count)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard let shoppingItem = ShoppingListController.sharedInstance.fetchResultsController.objectAtIndexPath(indexPath) as? ShoppingList else { return }
            ShoppingListController.sharedInstance.removeShoppingItem(shoppingItem)
        }
    }
    
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetail" {
            guard let detailVC = segue.destinationViewController as? DetailTableViewController, index = tableView.indexPathForSelectedRow, shoppingItem = ShoppingListController.sharedInstance.fetchResultsController.objectAtIndexPath(index) as? ShoppingList else { return }
            detailVC.shoppingItem = shoppingItem
        }
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        case .Insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Left)
        case .Move:
            guard let newIndexPath = newIndexPath, indexPath = indexPath else { return }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Left)
        case .Update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Left)
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Left)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func showAddAlert() {
        let alert = UIAlertController(title: "Add Shopping Item", message: "Please fill in all fields", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addTextFieldWithConfigurationHandler { (textFieldName) in
            textFieldName.placeholder = "Item Name"
            self.nameTextField = textFieldName
        }
        alert.addTextFieldWithConfigurationHandler { (textFieldCategory) in
            textFieldCategory.placeholder = "Location"
            self.categoryTextField = textFieldCategory
            self.categoryTextField.inputView = self.categoryPicker
            self.categoryPicker.selectRow(0, inComponent: 0, animated: true)
        }
        alert.addTextFieldWithConfigurationHandler { (textFieldCount) in
            textFieldCount.placeholder = "Number of Items"
            self.numberTextField = textFieldCount
            textFieldCount.inputView = self.numberPicker
            self.numberPicker.selectRow(0, inComponent: 0, animated: true)
        }
        let addAction = UIAlertAction(title: "Add", style: .Default) { (addAction) in
            guard let name = self.nameTextField.text, category = self.categoryTextField.text, countString = self.numberTextField.text, count = Int(countString) else { return }
            ShoppingListController.sharedInstance.addShoppingItem(name, category: category, itemCount: count)
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func addButtontapped(sender: UIBarButtonItem) {
        showAddAlert()
    }
    
    @IBOutlet var categoryPicker: UIPickerView!
    @IBOutlet var numberPicker: UIPickerView!
    
    func setupPickers() {
        categoryPicker.dataSource = self
        numberPicker.dataSource = self
        categoryPicker.delegate = self
        numberPicker.delegate = self
    }
    
    let categoryOptions: [String] = ["Macey's", "Costco", "Sams Club"]
    var numberOptions: [String] {
        var stringToReturn: [String] = []
        for i in 1...50 {
            stringToReturn += ["\(i)"]
        }
        return stringToReturn
    }
    
    //MARK: Data Source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return categoryOptions.count
        } else {
            return numberOptions.count
        }
        
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return categoryOptions[row]
        } else {
            return numberOptions[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            categoryTextField.text = categoryOptions[row]
        } else {
            numberTextField.text = numberOptions[row]
        }
    }
    
}
