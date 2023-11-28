//
//  SearchVCViewModel.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 07/11/23.
//

import Foundation
import RxCocoa
import RxSwift

class SearchViewModel {
    let api = CustomAPIManager()
    let bag = DisposeBag()
    let stateLoading = BehaviorRelay<StateLoading>(value: .loading)
    
    var dataNowPlaying = BehaviorRelay<NowPlaying?>(value: nil)
    
    func loadData<T: Codable>(for endpoint: Endpoint, resultType: T.Type) {
        
        stateLoading.accept(.loading)
        
        api.makeAPICall(endpoint: endpoint) { (response: Result<T, Error>)  in
            switch response {
            case .success(let data):
                switch endpoint { // Switch must be exhaustive
                case .getNowPlaying:
                    self.dataNowPlaying.accept(data as? NowPlaying )
                default:
                    break
                }
            case .failure(let error):
                // Handle the error
                print("Error fetching data for \(endpoint): \(error)")
            }
            
            self.stateLoading.accept(.fisnished)
        }
    }
}

enum StateLoading: Int {
    case loading, fisnished
}
