//
//  ListThirdEntity.swift
//  Test
//
//  Created by Muhammad Fahmi on 27/10/23.
//

import Foundation

struct SectionData {
    var title: String
    var data: ListThirdEntity
}

struct ListThirdEntity {
    var arraySatu: [String] {
        return (1...12).map { "Customised Cell: \($0)" }
    }
    
    var data: [String] {
        var dataArray = [String]()
        for i in 1...Int.random(in: 1...10) {
            let item = "Regular list: \(i)"
            dataArray.append(item)
        }
        return dataArray
    }
}

struct Person {
    var username: String
    var umur: Int
    var pekerjaan: String
}
