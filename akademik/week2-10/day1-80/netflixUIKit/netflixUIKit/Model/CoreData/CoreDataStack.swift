//
//  File.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 05/12/23.
//

import CoreData
import Foundation

class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "netflixUIKit")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    var managedContext: NSManagedObjectContext? {
        return persistentContainer.viewContext
    }
}
