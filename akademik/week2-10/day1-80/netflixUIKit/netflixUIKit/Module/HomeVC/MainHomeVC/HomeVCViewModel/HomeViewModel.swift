//
//  TableControllerViewModel.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 02/11/23.
//
import Foundation
import RxCocoa
import RxSwift

enum TableViewCellType: Int, CaseIterable {
    case VerticalCell
    case HorizontalCell
}

class HomeViewModel {
    let api = CustomAPIManager()
    
    var dataMoviePreviews = BehaviorRelay<Movie?>(value: nil)
    var dataMoviePopular = BehaviorRelay<Movie?>(value: nil)
    var dataFavoriteNoPaging = BehaviorRelay<Favorites?>(value: nil)
    
    func loadData<T: Codable>(for endpoint: Endpoint, resultType: T.Type) {
        
        api.makeAPICall(endpoint: endpoint) { (response: Result<T, Error>)  in
            switch response {
            case .success(let data):
                switch endpoint {
                case .getNowPlaying:
                    self.dataMoviePreviews.accept(data as? Movie)
                case .getPopular:
                    self.dataMoviePopular.accept(data as? Movie)
                case .getFavoriteNoPaging:
                    self.dataFavoriteNoPaging.accept(data as? Favorites)
                default:
                    break
                }
            case .failure(let error):
                // Handle the error
                print("Error fetching data for \(endpoint): \(error)")
            }
        }
    }
}
