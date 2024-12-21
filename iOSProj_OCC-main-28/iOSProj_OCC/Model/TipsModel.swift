//
//  TipsModel.swift
//  iOSProj_OCC
//
//  Created by Karly Ripper on 11/25/24.
//

import Foundation

struct TipsModel: Decodable, Identifiable {
    var id : String
    var header : String
    var lists : [InfoList]
    enum CodingKeys: String, CodingKey{
        case id
        case header
        case lists
    }
}

struct InfoList: Decodable, Identifiable {
    var id : Int
    var title : String
    var description : String
    var info : [String]
    var website : String? = nil
    enum CodingKeys: String, CodingKey{
        case id
        case title
        case description
        case info
        case website
    }
}
