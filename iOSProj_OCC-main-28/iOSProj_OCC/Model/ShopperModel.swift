//
//  ShopperModel.swift
//  iOSProj_OCC
//
//  Created by Ruby Greathouse on 11/10/24.
//

import Foundation

class ShopperModel: ObservableObject {
    
    @Published var boyIsChecked = true
    @Published var girlIsChecked = false
    
    @Published var  toddlerIsChecked  = false
    @Published var  childIsChecked = false
    @Published var  adolescentIsChecked = false
        
        
        func getStores(online: Bool) -> [String] {
            if online {
                return ["WowSupplies", "Amazon"]
            } else {
                return ["Walmart", "Target", "DollarGeneral", "DollarTree", "HobbyLobby"]
            }
        }
}
