//
//  iOSProj_OCCApp.swift
//  iOSProj_OCC
//
//  Created by Ruby Greathouse on 11/9/24.
//

import SwiftUI

@main
struct iOSProj_OCCApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Theme())
                .environmentObject(ShopperModel())
                .environmentObject(StepsViewModel())
                .environmentObject(TipsViewModel())
                .environmentObject(ShoppingViewModel())
                .environmentObject(GameModel())
                
        }
    }
}
