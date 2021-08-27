//
//  ProfileProvider.swift
//  RAWG
//
//  Created by Iman Faizal on 24/08/21.
//

import Foundation
import CoreData

class DatabaseProvider {
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Database")
            
            container.loadPersistentStores { _, error in
                guard error == nil else {
                    fatalError("Unresolved error \(error!)")
                }
            }
            container.viewContext.automaticallyMergesChangesFromParent = false
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            container.viewContext.shouldDeleteInaccessibleFaults = true
            container.viewContext.undoManager = nil
            
            return container
        }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
            taskContext.undoManager = nil
            
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            return taskContext
    }
    
    func getProfile(completion: @escaping(_ profiles: ProfileModel) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Profile")
            fetchRequest.fetchLimit = 1
            do {
                if let result = try
                    taskContext.fetch(fetchRequest).first {
                    let profile = ProfileModel(
                        photo: result.value(forKeyPath:
                            "photo") as? Any,
                        name: result.value(forKeyPath:
                            "name") as? String,
                        email: result.value(forKeyPath:
                            "email") as? String
                    )
                    
                    completion(profile)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func updateProfile(
        _ photo: Any,
        _ name: String,
        _ email: String,
        completion: @escaping() -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Profile")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "name == \(name)")
            if let result = try? taskContext.fetch(fetchRequest), let profile = result.first as? Profile {
                profile.setValue(photo, forKey: "photo")
                profile.setValue(name, forKey: "name")
                profile.setValue(email, forKey: "email")
                
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
        
    }
    
    func getAllFavorite(completion: @escaping(_ favorites: [FavoriteModel]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            do {
                let results = try taskContext.fetch(fetchRequest)
                var favorites: [FavoriteModel] = []
                for result in results {
                    let favorite = FavoriteModel(
                        id: result.value(forKeyPath: "id") as? Int,
                        name: result.value(forKeyPath: "name" ) as? String,
                        backgroundImage: result.value(forKeyPath: "background_image") as? String,
                        released: result.value(forKeyPath: "released") as? String,
                        rating: result.value(forKeyPath: "rating") as? Double,
                        ratingTop: result.value(forKeyPath: "rating_top") as? Int
                    )
                    
                    favorites.append(favorite)
                }
                completion(favorites)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func addFavorites(
        _ id: Int,
        _ name: String,
        _ backgroundImage: String,
        _ released: String,
        _ rating: Double,
        _ ratingTop: Int,
        completion: @escaping() -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: taskContext) {
                
                let favorite = NSManagedObject(entity: entity, insertInto: taskContext)
                
                favorite.setValue(id, forKeyPath: "id")
                favorite.setValue(name, forKeyPath: "name")
                favorite.setValue(backgroundImage, forKeyPath: "background_image")
                favorite.setValue(released, forKeyPath: "released")
                favorite.setValue(rating, forKeyPath: "rating")
                favorite.setValue(ratingTop, forKeyPath: "rating_top")
                
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            
        }
    }


    func removeFavorite(_ id: Int, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }
    
    func removeAllFavorite(completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }
    
    func checkFavoritesById(_ id: Int, completion: @escaping(_ value: Bool) -> Void) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                let results = try taskContext.fetch(fetchRequest)
                let result = results.first
                if result != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}
