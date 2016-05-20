//
//  ShoppingListController.swift
//  ShoppingList
//
//  Created by AJ Bronson on 5/20/16.
//  Copyright © 2016 PrecisionCodes. All rights reserved.
//

import Foundation
import CoreData

class ShoppingListController {
    
    static let sharedInstance = ShoppingListController()
    let moc = Stack.sharedStack.managedObjectContext
    
    let fetchResultsController: NSFetchedResultsController
    
    init() {
        let request = NSFetchRequest(entityName: "ShoppingList")
        let sortDescriptor1 = NSSortDescriptor(key: "category", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "dateCreated", ascending: true)
        request.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "category", cacheName: nil)
        _ = try? fetchResultsController.performFetch()
    }
    
    func addShoppingItem(name: String, category: String, itemCount: Int) {
        let _ = ShoppingList(name: name, category: category, itemCount: itemCount)
        save()
    }
    
    func updateShoppingItem(shoppingItem: ShoppingList, name: String, category: String, itemCount: Int) {
        shoppingItem.name = name
        shoppingItem.category = category
        shoppingItem.itemCount = itemCount
        save()
    }
    
    func removeShoppingItem(shoppingItem: ShoppingList) {
        shoppingItem.managedObjectContext?.deleteObject(shoppingItem)
        save()
    }
    
    func save() {
        do {
           _ = try moc.save()
        } catch {
            print("Error saving object")
        }
    }
}