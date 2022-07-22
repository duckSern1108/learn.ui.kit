//
//  MainViewController.swift
//  learn.ui.kit
//
//  Created by ghtk on 27/06/2022.
//

import UIKit
import PromiseKit

class MainViewController: UIViewController {
    var coordinator: MainCoordinator?
    
    private var viewModel = MainViewModel()
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup collection view
        let imageCell = UINib(nibName: "ImageCell", bundle: .main)
        let header = UINib(nibName: "Header", bundle: .main)
        collectionView.register(imageCell, forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(header, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        //set up navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Login",
            style: .plain,
            target: self,
            action: #selector(button)
        )
        //        navigationController?.navigationBar.tintColor = .red
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search artists"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        self.title = "Hot albums"
        
        //viewmodel
        viewModel.delegate = self
        
        self.loadMusicData()
    }
    
    func loadMusicData() {
        let loadingVC = LoadingViewController()
        add(loadingVC)
        firstly {
            viewModel.loadMusicDataUsePromiseKit()
        }.done{
            loadingVC.remove()
        }
        
    }
    
    @objc func button() {
        print("Hello button pressed")
        coordinator?.goToLogin(delegate: nil)
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width - 16
        return CGSize(width: screenWidth/2, height: (screenWidth/3)*5/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let data = viewModel.filteredMusics[indexPath.row]
        cell.bindData(labelText: data.name, imageUrl: data.artworkUrl100)        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.filteredMusics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader :
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! Header
            header.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: 50)
            header.bindData(countLabelText: "\(viewModel.filteredMusics.count)")            
            return header
        default:
            fatalError("asdfasdfasd")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //if selected item is equal to current selected item, ignore it
        coordinator?.goToLogin(delegate: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    
}

extension MainViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterMusics(term: searchController.searchBar.text)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        viewModel.filterMusics(term: nil)
    }
}

extension MainViewController: MainViewModelDelegate {
    func onFilteredMusicUpdate(_ viewModel: MainViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
    }
}


