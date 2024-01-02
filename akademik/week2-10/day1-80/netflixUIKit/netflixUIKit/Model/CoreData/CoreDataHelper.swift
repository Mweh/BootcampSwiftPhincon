//
//  File.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 07/12/23.
//

import CoreData
import Foundation
import UIKit

// MARK: - CoreDataHelper

class CoreDataHelper {
    static let shared = CoreDataHelper()

    // Use the persistentContainer from the AppDelegate
    private let persistentContainer: NSPersistentContainer

    private init() {
        self.persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    // MARK: - Fetch History Movies

    func fetchHistoryMovies() -> [HistoryModelMovie]? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            var historyMovies: [HistoryModelMovie] = []
            
            if let movieItems = fetchedResults as? [NSManagedObject] {
                for item in movieItems {
                    if let id = item.value(forKey: "id") as? Int,
                       let posterPath = item.value(forKey: "posterPath") as? String,
                       let title = item.value(forKey: "title") as? String,
                       let genres = item.value(forKey: "genres") as? String,
                       let voteAverage = item.value(forKey: "voteAverage") as? Double,
                       let releaseDate = item.value(forKey: "releaseDate") as? String,
                       let runtime = item.value(forKey: "runtime") as? Int
                    {
                        let movieItem = HistoryModelMovie(id: id, posterPath: posterPath, title: title, voteAverage: voteAverage, genres: genres, releaseDate: releaseDate, runtime: runtime)
                        historyMovies.append(movieItem)
                    }
                }
            }
            
            return historyMovies
        } catch {
            // Failed to fetch data: \(error)
            return nil
        }
    }
    
    // MARK: - Fetch Total History
    
    func fetchTotalHistoryMovies() -> Int {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        do {
            let totalMovies = try context.count(for: fetchRequest)
            return totalMovies
        } catch { // Failed to fetch total history movies: \(error)"
            return 0
        }
    }
    
    // MARK: - Save HistoryModelMovie

    func saveMovieToHistory(data: HistoryModelMovie) {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", data.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let _ = results.first as? NSManagedObject {
                // Movie with the same ID already exists, you can update or skip
                // For simplicity, let's just skip adding the duplicate
                
                // if Movie with ID \(data.id) already exists in history.
            } else {
                // Movie with this ID doesn't exist, proceed to add it
                if let movieEntity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: context) {
                    let movieItem = NSManagedObject(entity: movieEntity, insertInto: context)
                    
                    movieItem.setValue(data.id, forKey: "id")
                    movieItem.setValue(data.posterPath, forKey: "posterPath")
                    movieItem.setValue(data.title, forKey: "title")
                    movieItem.setValue(data.voteAverage, forKey: "voteAverage")
                    movieItem.setValue(data.genres, forKey: "genres")
                    movieItem.setValue(data.releaseDate, forKey: "releaseDate")
                    movieItem.setValue(data.runtime, forKey: "runtime")
                    
                    do {
                        try context.save()
                        print("Saved to history")
                        
                        // Post a notification when the save is successful
                        NotificationCenter.default.post(name: .historyMovieSaved, object: nil)
                    } catch {
                        print("Failed to save item to history: \(error)")
                    }

                }
            }
        } catch {
            print("Error fetching existing movie: \(error)")
        }
    }
    
    // MARK: - Clear Core Data Cache
    
    func clearCoreDataCache(completion: @escaping (Result<Void, Error>) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //Value of type 'AppDelegate' has no member 'persistentContainer'
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        do {
            let entities = try context.fetch(fetchRequest)
            for entity in entities {
                context.delete(entity as! NSManagedObject)
            }
            try context.save()
            
            // Call the completion handler with success
            completion(.success(()))
        } catch {
            // Call the completion handler with failure and pass the error
            completion(.failure(error))
        }
    }
}
