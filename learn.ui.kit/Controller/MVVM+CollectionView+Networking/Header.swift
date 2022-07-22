//
//  Header.swift
//  learn.ui.kit
//
//  Created by ghtk on 27/06/2022.
//

import UIKit

class Header: UICollectionReusableView {
    @IBOutlet weak var countLabel: UILabel!
    var onEditEnd: (_ text: String?) -> () = {text in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func bindData(countLabelText: String) {
        countLabel.text = countLabelText
    }
}
