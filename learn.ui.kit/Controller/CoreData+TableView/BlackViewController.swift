//
//  BlackViewController.swift
//  learn.ui.kit
//
//  Created by ghtk on 24/06/2022.
//

import UIKit
import Alamofire
import PromiseKit
import CoreData

class BlackViewController: UIViewController {
    
    var coordinator: MainCoordinator?
    
    let refreshControl = UIRefreshControl()
    
    
    var fetchedResultsController: NSFetchedResultsController<MusicCoreData>!
    
    @IBOutlet weak var tableView: UITableView!
    
    //core data
    //init fetch result
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
    
    @IBAction func onDeleteAllItem(_ sender: Any) {
        self.deleteAll()
        tableView.reloadData()
    }
    @IBAction func onAddItem(_ sender: Any) {
        save(name: "Son", artistName: "Son", artworkUrl100: "https://picsum.photos/200/300")
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
    
    func initializeFetchedResultsController() {
        
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
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top albums"
        // Do any additional setup after loading the view.
        let musicCellNib = UINib(nibName: "MusicCell", bundle: .main)
        tableView.register(musicCellNib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.refreshControl = refreshControl
        initializeFetchedResultsController()
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
    }
    
    @objc func reload(){
        self.refreshControl.endRefreshing()
    }
    
    
    
    func goToLogin() {
        coordinator?.goToLogin(delegate: self)
    }
}

extension BlackViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController?.fetchedObjects!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MusicCell
        let cellData = fetchedResultsController.object(at: indexPath)
        cell.nameLabel?.text = cellData.name!
        cell.artitstNameLabel?.text = cellData.artistName!
        cell.artWork100ImageView?.loadFromUrl(URLAddress: cellData.artworkUrl100!)
        cell.onDeleteItem = {
            [weak self] currentCell in
            let actualIndexPath = tableView.indexPath(for: currentCell)!
            print(actualIndexPath)
            self?.delete(at: actualIndexPath)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToLogin()
    }
}

extension BlackViewController: PinkViewDelegate {
    func onLoginTapped(username: String?, email: String?) {
        print(username!, email!)
    }
}

extension BlackViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            print("insert")
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            print("delete")
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            print("update")
            tableView.reloadRows(at: [indexPath!], with: .automatic)
            break;
        default:
            print("default")
        }
    }
}
