////
////  PokeViewCell.swift
////  Test
////
////  Created by Muhammad Fahmi on 27/10/23.
////
//
//import UIKit
//
//class PokeViewCell: UITableViewCell {
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//        
//    }
//    
//    func fetchPokemonNames(completion: @escaping ([String]?) -> Void) {
//        if let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20") {
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if let data = data {
//                    do {
//                        let decoder = JSONDecoder()
//                        let result = try decoder.decode(PokemonResult.self, from: data)
//                        completion(result.results.map { $0.name })
//                    } catch {
//                        completion(nil)
//                    }
//                } else {
//                    completion(nil)
//                }
//            }
//            task.resume()
//        } else {
//            completion(nil)
//        }
//    }
//    
//    
//}
//
//
