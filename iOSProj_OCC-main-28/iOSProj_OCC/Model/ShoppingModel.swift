//
//  ShoppingModel.swift
//  iOSProj_OCC
//
//  Created by Ruby Greathouse on 12/4/24.
//
import Foundation

struct Item: Identifiable, Decodable, Hashable {
    var id = UUID()
    let item: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case item
        case image
    }
}

struct Category: Identifiable, Decodable {
    var id = UUID()
    let name: String
    let contentGirl: [Item]
    let contentBoy: [Item]
    let doNotSend: [Item]
    let color: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case contentGirl
        case contentBoy
        case doNotSend
        case color
    }
    
}

struct ShoppingData: Decodable {
    let categories: [Category]
}
