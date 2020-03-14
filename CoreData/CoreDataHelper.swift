//
//  CoreDataHelper.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/8/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    static var managedContext : NSManagedObjectContext {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    static func save() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            Debug.log("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func delete(entity : NSManagedObject) {
        managedContext.delete(entity)
    }
    
    static func vehicle(withVIN vin: String?) -> Vehicle? {
        guard let vin = vin else { return nil }
        let fetch = NSFetchRequest<Vehicle>(entityName: "Vehicle")
        fetch.predicate = NSPredicate(format: "vin = %@", vin)
        return try? managedContext.fetch(fetch).first
    }
    
}
