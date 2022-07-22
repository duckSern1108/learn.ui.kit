//
//  MusicCoreDataController.swift
//  learn.ui.kit
//
//  Created by ghtk on 22/07/2022.
//

import UIKit
import CoreData

class MusicCoreDataController {
    var fetchedResultsController: NSFetchedResultsController<MusicCoreData>!
    init(delegate: NSFetchedResultsControllerDelegate) {
        initializeFetchedResultsController(delegate: delegate)
    }
    
    func delete(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // lấy Managed Object Context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // lấy item ra để xoá
        let user = fetchedResultsController.object(at: indexPath)
        
        // delete
        managedContext.delete(user)
        
        //save context
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func save(name: String, artistName: String, artworkUrl100: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "MusicCoreData", in: managedContext)!
        
        let music = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let id = Int.random(in: 1...1000)
        
        music.setValue(name, forKeyPath: "name")
        music.setValue(String(id), forKeyPath: "id")
        music.setValue(artistName, forKeyPath: "artistName")
        music.setValue(artworkUrl100, forKey: "artworkUrl100")
        
        do {
            try managedContext.save()
            //            print("save success")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAll() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // lấy Managed Object Context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create Fetch Request
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicCoreData")
        
        // Initialize Batch Delete Request
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            // execute delete
            try managedContext.execute(deleteRequest)
            
            // save
            try managedContext.save()
            
            // Perform Fetch
            try self.fetchedResultsController.performFetch()
            
            // Reload Table View
            //            self.tableView.reloadData()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func initializeFetchedResultsController(delegate: NSFetchedResultsControllerDelegate) {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<MusicCoreData> = MusicCoreData.fetchRequest()
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // lấy AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // lấy Managed Object Context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        fetchedResultsController = NSFetchedResultsController<MusicCoreData>(fetchRequest: fetchRequest,
                                                                             managedObjectContext: managedContext,
                                                                             sectionNameKeyPath: nil,
                                                                             cacheName: nil)
        
        fetchedResultsController.delegate = delegate
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
}
