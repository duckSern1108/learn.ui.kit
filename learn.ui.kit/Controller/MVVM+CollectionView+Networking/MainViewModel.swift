//
//  MainViewModel.swift
//  learn.ui.kit
//
//  Created by ghtk on 04/07/2022.
//

import Foundation
import PromiseKit

protocol MainViewModelDelegate: AnyObject {
    func onFilteredMusicUpdate(_ viewModel: MainViewModel) -> Void
}

class MainViewModel {
    var fetchedMusics: [Music] = []
    var filteredMusics: [Music] = [] {
        didSet {
            delegate?.onFilteredMusicUpdate(self)
        }
    }
    weak var delegate: MainViewModelDelegate?
    func loadMusicDataUsePromiseKit() -> Promise<Void> {
        return firstly {
            PromiseRouter.promiseGetHotMusic()
        }.done { data in
            self.fetchedMusics = data.musics
            self.filteredMusics = data.musics
        }
    }
    
    func loadMusicData(completion:@escaping () -> Void) {
        APIMusic.getHotMusic(limit: 10) { response in
            switch response {
            case .failure(let error):
                print(error)
            case .success(let data):
                self.fetchedMusics = data.musics
                self.filteredMusics = data.musics
            }
            completion()
            
        }
    }
    
    func filterMusics(term: String?) {
        guard let term = term else {
            self.filteredMusics = self.fetchedMusics
            return
        }
        self.filteredMusics = self.fetchedMusics.filter({item in item.name.contains(term)})
    }
}
