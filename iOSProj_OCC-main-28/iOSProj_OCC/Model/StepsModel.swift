//
//  StepsModel.swift
//  iOSProj_OCC
//
//  Created by Ruby Greathouse on 11/12/24.
//

import Foundation

struct StepsModel : Decodable, Identifiable {
    var id : Int
    var title : String
    var description : String
    var additional : [String]?
}
