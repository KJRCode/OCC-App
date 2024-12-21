//
//  ShoppingViewModel.swift
//  iOSProj_OCC
//
//  Created by Ruby Greathouse on 12/4/24.
//
import Foundation
import SwiftUI

class ShoppingViewModel: ObservableObject {
    @Published var categories: [Category] = []

    init() {
        readJSON()
    }
    
    func getColor(for colorName: String) -> Color {
        switch colorName.lowercased() {
        case "blue":
            return Color.blue
        case "red":
            return Color.red
        case "green":
            return Color.green
        case "purple":
            return Color.purple
        default:
            return Color.gray
        }
    }
    
    
    // This method will read the JSON file and parse it into the 'categories' array
    func readJSON() {
        // 1. Get the path to the json file
        guard let pathString = Bundle.main.path(forResource: "shopping", ofType: "json") else {
            print("Failed to locate the JSON file.")
            return
        }

        // 2. Create a URL object from the path
        let url = URL(fileURLWithPath: pathString)
        
        // 3. Create a Data object from the URL to fetch the data
        do {
            let data = try Data(contentsOf: url)
            
            // 4. Parse the data using a JSONDecoder
            let jsonDecoder = JSONDecoder()
            
            // 5. Decode the data into a ShoppingData object
            let decodedData = try jsonDecoder.decode(ShoppingData.self, from: data)
            
            // 6. Successfully decoded, update the published categories array
            self.categories = decodedData.categories
            print("this is the count: \(self.categories.count)")
            
        } catch {
            print("Error decoding JSON data: \(error)")
        }
    }
}
