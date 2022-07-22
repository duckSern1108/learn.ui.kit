//
//  UIImageView.ext.swift
//  learn.ui.kit
//
//  Created by ghtk on 22/07/2022.
//

import UIKit

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
