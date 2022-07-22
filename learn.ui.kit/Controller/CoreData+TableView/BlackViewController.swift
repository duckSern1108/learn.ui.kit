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
    
    var musicCoreDataController: MusicCoreDataController!
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!    
    
    @IBAction func onDeleteAllItem(_ sender: Any) {
        musicCoreDataController?.deleteAll()
        tableView.reloadData()
    }
    @IBAction func onAddItem(_ sender: Any) {
        musicCoreDataController.save(name: "Son", artistName: "Son", artworkUrl100: "https://picsum.photos/200/300")
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
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        musicCoreDataController = MusicCoreDataController(delegate: self)
        
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
        musicCoreDataController.fetchedResultsController?.fetchedObjects!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MusicCell
        let cellData = musicCoreDataController.fetchedResultsController.object(at: indexPath)
        cell.bindData(cellData: cellData)
        cell.onDeleteItem = {
            [weak self] currentCell in
            let actualIndexPath = tableView.indexPath(for: currentCell)!
            self?.musicCoreDataController.delete(at: actualIndexPath)
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
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
            break;
        default:
            break;
        }
    }
}
