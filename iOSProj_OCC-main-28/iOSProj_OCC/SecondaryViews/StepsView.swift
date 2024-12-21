//
//  StepsView.swift
//  iOSProj_OCC
//
//  Created by Ruby Greathouse on 11/12/24.
//


import SwiftUI

struct StepsView: View {
    @EnvironmentObject var VM: StepsViewModel
    @EnvironmentObject var theme: Theme
    @State var selectedTab: Int = 0
    @State var showMap: Bool = false
    @State var sheetOn: Bool = false
    @State var showComplete : Bool = false
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!)
                .ignoresSafeArea()
            
            NavigationStack {
                VStack {
                    TabView (selection: $selectedTab){
                        ForEach(VM.steps.indices, id: \.self) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(UIColor(hex: theme.darkMode ? theme.darkC1 : theme.lightColor)!)).cornerRadius(20).shadow(color: Color(.gray), radius: 8)
                                    .frame(width: 370, height: 500)
                                
                                VStack{
                                    VStack {
                                        Text("\(VM.steps[index].id). \(VM.steps[index].title)")
                                            .bold()
                                            .font(.system(size: 35))
                                            .padding(.top, 50)
                                    }.frame(height: 100)
                                    
                                    VStack {
                                        Text(VM.steps[index].description)
                                            .frame(width: 300)
                                            .lineSpacing(10)
                                            .padding(.bottom)
                                        
                                        
                                        
                                        if let additionalText = VM.steps[index].additional {
                                            VStack(alignment: .leading, spacing: 5) {
                                                ForEach(additionalText, id: \.self) { item in
                                                    HStack (alignment: .top) {
                                                        Text("•")
                                                            .font(.system(size: 30))
                                                            
                                                        Text(item)
                                                            .lineSpacing(7)
                                                        
                                                        
                                                    }
                                                }
                                            }.frame(width: 300)
                                            
                                        }
                                        
                                    }.frame(height: 400)
                                    
                                }
                                .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                                
                            }
                            .tag(index)
                            
                        } // for each
                    } // tab view
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                    VStack {
                        HStack {
                            // Previous Button
                            Button(action: {
                                if selectedTab > 0 {
                                    selectedTab -= 1
                                }
                            }) {
                                Text("Previous")
                                    .font(.title3)
                                    .foregroundColor(.purple)
                                    .frame(width: 150)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray).opacity(0.2))
                            }
                            .disabled(selectedTab == 0)
                            
                            // Next Button
                            Button(action: {
                                if selectedTab < VM.steps.count - 1 {
                                    selectedTab += 1
                                }
                                else{
                                    sheetOn = true
                                    showComplete = true
                                }
                            }) {
                                Text(selectedTab == VM.steps.count - 1 ? "Done" : "Next")
                                    .font(.title3)
                                    .foregroundColor(Color.white)
                                    .frame(width: 150)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 15).fill(Color(UIColor(hex: theme.accentColor)!)))
                                
                                
                            }
                        }
                    }.padding(.bottom, 50)
                    
                    NavigationLink("", destination: CompletionView(), isActive: $showComplete)
                        .hidden()
                    
                }
                .navigationBarBackButtonHidden(true) // Hide the default back button
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        // Custom back button
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "house")
                                .foregroundColor(Color(UIColor(hex: theme.accentColor2)!))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StepsView()
        .environmentObject(StepsViewModel())
        .environmentObject(Theme())
        .environmentObject(TipsViewModel())
}
