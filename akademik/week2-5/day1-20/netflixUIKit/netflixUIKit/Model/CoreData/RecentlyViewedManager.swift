//
//  MovieEntity.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 05/12/23.
//

import CoreData
import Foundation

class RecentlyViewedManager {
    static let shared = RecentlyViewedManager()

    private init() {}

    func addRecentlyViewed(movieID: Int) {
        guard let context = CoreDataStack.shared.managedContext else { return }

        let recentlyViewed = RecentlyViewed(context: context)
        recentlyViewed.id = Int32(movieID)

        saveContext()
    }

    func getRecentlyViewed() -> [MovieEntity] {
        guard let context = CoreDataStack.shared.managedContext else { return [] }

        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()

        do {
            let recentlyViewedObjects = try context.fetch(fetchRequest)
            return recentlyViewedObjects
        } catch {
            print("Error fetching recently viewed movies: \(error)")
            return []
        }
    }

    private func saveContext() {
        guard let context = CoreDataStack.shared.managedContext else { return }

        do {
            try context.save()
        } catch {
            print("Error saving Core Data context: \(error)")
        }
    }
}
