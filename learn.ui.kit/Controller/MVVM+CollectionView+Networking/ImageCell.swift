//
//  ImageCell.swift
//  learn.ui.kit
//
//  Created by ghtk on 27/06/2022.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindData(labelText: String ,imageUrl: String) {
        label.text = labelText
        image.loadFromUrl(URLAddress: imageUrl)
    }
    
}
