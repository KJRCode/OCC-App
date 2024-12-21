//
//  ThemeModel.swift
//  iOSProj_OCC
//
//  Created by Ruby Greathouse on 11/10/24.
//

import Foundation


class Theme: ObservableObject {
    @Published var darkMode: Bool = false
    @Published var lightColor: String = "#F5F5F5"
    @Published var darkColor : String = "#1F1F1F"
    
    @Published var accentColor : String = "#04994B"
    @Published var accentColor2 : String = "#DC2E45"
    
    @Published var darkA1 : String = "#61FAAB"
    @Published var darkA2 : String  = "#DE3F54"
    @Published var darkC1 : String = "#333333"
}
