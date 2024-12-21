//
//  CompletionView.swift
//  iOSProj_OCC
//
//  Created by Ruby Greathouse on 11/12/24.
//

import SwiftUI

struct SuperTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
    
}

struct CompletionView: View {
    
    @EnvironmentObject var theme: Theme
    @State var zipCode: String = ""
    @State var sheetOn: Bool = false
    @State var showMap: Bool = false
    @State var isZipCodeValid: Bool = false
    
    @State var showConfetti = false
 
    
    
    func isValidZipCode(_ zip: String) -> Bool {
        let zipCodeRegEx = "^[0-9]{5}$"
        let zipCodeTest = NSPredicate(format: "SELF MATCHES %@", zipCodeRegEx)
        return zipCodeTest.evaluate(with: zip)
    }
    
    func updateValidationState() {
        isZipCodeValid = isValidZipCode(zipCode)
    }
 
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!)
                    .ignoresSafeArea()
                VStack {
                    
                    Text("Hooray!")
                        .font(.system(size: 40 , weight: .bold))
                        .padding()
                    Text("You just finished packing a box!")
                        .font(.headline)
                    
                    Spacer()
                        .frame(height: 60)
                    Text("To find your nearest processing center")
                    
                    SuperTextField(
                        placeholder: Text("Enter your zip code").foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!).opacity(0.5)), text: $zipCode)
//                    TextField("Enter your zip code", text: $zipCode)
                        .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                        .frame(width: 300, height: 30)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color(UIColor(hex: theme.darkMode ? theme.darkC1 : theme.lightColor)!)).stroke(Color.gray, lineWidth: 1)
                    )
                       
                        .keyboardType(.numberPad)
                        
                        
                        .onChange(of: zipCode) { _ in
                            updateValidationState()
                        }
                    
                    Button {
                        sheetOn = true
                    } label: {
                        Text("Enter")
                            .font(.title3)
                            .foregroundColor(Color.white)
                            .frame(width: 300, height: 30)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(isZipCodeValid ? Color(UIColor(hex: theme.accentColor)!) : Color.gray))
                            .opacity(isZipCodeValid ? 1 : 0.9)
                        
                        
                    }.disabled(!isZipCodeValid)
                    
                    //                Text("Your Zip Code is: \(zipCode)")
                    //                    .padding()
                    
                    
                    
                }
                .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                .displayConfetti(isActive: $showConfetti)
                .onAppear() {
                    showConfetti = true
                }
                
                .sheet(isPresented: $sheetOn) {
                    MapView(showMap: $showMap, zipCode: zipCode)
                }
                
                .padding()
                
            }
        }
        

    }
}

#Preview {
    CompletionView()
        .environmentObject(Theme())
        .environmentObject(TipsViewModel())
    
}
