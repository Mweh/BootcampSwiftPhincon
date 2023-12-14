//
//  DiscoverViewModel.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 13/11/23.
//

import Foundation
import RxCocoa
import RxSwift

class DiscoverViewModel {
    let api = CustomAPIManager()
    let bag = DisposeBag()
    let stateLoading = BehaviorRelay<StateLoading>(value: .loading)
    
    var dataMovie = BehaviorRelay<Movie?>(value: nil)
    
    func loadData<T: Codable>(for endpoint: Endpoint, resultType: T.Type) {
        
        stateLoading.accept(.loading)
        
        api.makeAPICall(endpoint: endpoint) { (response: Result<T, Error>)  in
            switch response {
            case .success(let data):
                switch endpoint { // Switch must be exhaustive
                case .getNowPlaying:
                    self.dataMovie.accept(data as? Movie )
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
