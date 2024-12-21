//
//  StepsViewModel.swift
//  iOSProj_OCC
//
//  Created by Ruby Greathouse on 11/12/24.
//

import Foundation

class StepsViewModel : ObservableObject {
    @Published var steps: [StepsModel] = []
    
    init(){
        readJSON()
    }
    
    func readJSON() {
        // 1. Get the path to json file
        let pathString = Bundle.main.path(forResource: "stepsToPack", ofType: "json")
        
        if let path = pathString{
            // 2. Create a URL object
            let url = URL(fileURLWithPath: path)
            
            // 3. Create a Data Object with the URL file to fetch the data
            do {
                let data = try Data(contentsOf: url)
                
                // 4. Parse the data with a JSON Decoder
                let json_decoder = JSONDecoder()
                
                // 5. extract the models from the file
                // if the struct does not match with the json object, it will fail
                let jsonData = try json_decoder.decode([StepsModel].self, from: data)
                
                // if succeed
                self.steps = jsonData
            
            } catch {
                print(error)
            }
            
        }
        
        
    }
    
}
