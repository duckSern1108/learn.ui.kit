//
//  DetailViewController.swift
//  learn.ui.kit
//
//  Created by ghtk on 22/07/2022.
//

import UIKit

class DetailViewController: UIViewController {
        
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    var data: Music!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.loadFromUrl(URLAddress: data.artworkUrl100)
        title = data.name        
        artistNameLabel.text = data.artistName
        releaseDateLabel.text = data.releaseDate
        genresLabel.text = data.genresLabel
    }
    
    
}
