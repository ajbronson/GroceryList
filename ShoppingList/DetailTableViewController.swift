//
//  DetailTableViewController.swift
//  ShoppingList
//
//  Created by AJ Bronson on 5/20/16.
//  Copyright © 2016 PrecisionCodes. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var nametextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet var categoryItems: UIPickerView!
    @IBOutlet var numberPicker: UIPickerView!
    
    
    var shoppingItem: ShoppingList?
    
    let categoryOptions: [String] = ["Macey's", "Costco", "Sams Club"]
    var numberOptions: [String] {
        var stringToReturn: [String] = []
        for i in 1...50 {
            stringToReturn += ["\(i)"]
        }
        return stringToReturn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWith()
        setupPickerView()
        setupDefaultPickerLocations()
    }
    
    func setupPickerView() {
        categoryItems.dataSource = self
        categoryItems.delegate = self
        numberPicker.dataSource = self
        numberPicker.delegate = self
        self.categoryTextField.inputView = categoryItems
        self.countTextField.inputView = numberPicker
    }
    
    func updateWith() {
        guard let shoppingItem = shoppingItem, count = shoppingItem.itemCount else { return }
        nametextField.text = shoppingItem.name
        categoryTextField.text = shoppingItem.category
        countTextField.text = "\(count)"
    }
    
    @IBAction func savebuttonTapped(sender: UIBarButtonItem) {
        guard let shoppingItem = shoppingItem, name = nametextField.text, category = categoryTextField.text, countString = countTextField.text where name.characters.count > 0 && category.characters.count > 0 && countString.characters.count > 0 else { return }
        guard let count = Int(countString) else { return }
        ShoppingListController.sharedInstance.updateShoppingItem(shoppingItem, name: name, category: category, itemCount: count)
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancelButtontapped(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: Data Source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryItems {
            return categoryOptions.count
        } else {
            return numberOptions.count
        }
        
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryItems {
            return categoryOptions[row]
        } else {
            return numberOptions[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryItems {
            categoryTextField.text = categoryOptions[row]
        } else {
            countTextField.text = numberOptions[row]
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == categoryTextField{
            return true
        } else {
            return true
        }
        
    }
    
    func setupDefaultPickerLocations() {
        if let item = shoppingItem {
            for i in 0..<categoryOptions.count {
                if categoryOptions[i] == item.category {
                    categoryItems.selectRow(i, inComponent: 0, animated: true)
                }
            }
            
            for i in 0..<numberOptions.count {
                guard let itemCount = item.itemCount else { return }
                if numberOptions[i] == String(itemCount) {
                    numberPicker.selectRow(i, inComponent: 0, animated: true)
                }
            }
        }
    }
    

    
}
