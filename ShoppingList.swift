//
//  ShoppingList.swift
//  ShoppingList
//
//  Created by AJ Bronson on 5/20/16.
//  Copyright © 2016 PrecisionCodes. All rights reserved.
//

import Foundation
import CoreData


class ShoppingList: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    convenience init(name: String, dateCreated: NSDate = NSDate(), category: String, itemCount: Int = 1, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        let entity = NSEntityDescription.entityForName("ShoppingList", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.name = name
        self.dateCreated = dateCreated
        self.category = category
        self.itemCount = itemCount
    }
}
