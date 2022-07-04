//
//  MusicCell.swift
//  learn.ui.kit
//
//  Created by ghtk on 24/06/2022.
//

import UIKit

class MusicCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artitstNameLabel: UILabel!
    @IBOutlet weak var artWork100ImageView: UIImageView!
    
    var onDeleteItem:(UITableViewCell) -> Void = { c in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        artWork100ImageView.layer.cornerRadius = 16
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onDeleteItem(_ sender: Any) {
        self.onDeleteItem(self)
    }
}


extension UIImageView {
    func loadFromUrl(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}
