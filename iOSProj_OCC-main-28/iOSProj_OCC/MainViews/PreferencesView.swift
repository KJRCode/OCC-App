//
//  ProfileView.swift
//  iOSProj_OCC
//
//  Created by Ruby Greathouse on 11/10/24.
//

import SwiftUI

enum Gender: String, CaseIterable, Identifiable {
    case girl, boy
    var id: Self { self }
}

enum Age: String, CaseIterable, Identifiable {
    case toddler = "2-4"
    case child = "5-9"
    case adolescent = "10-14"
    var id: Self { self }
}

struct CustomSegmentedView: View {
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var tips: TipsViewModel
    @Binding var currentIndex: Int
    var selections: [String]
    
    init(_ currentIndex: Binding<Int>, selections: [String]) {
        self._currentIndex = currentIndex
        self.selections = selections
    }
    
  
    private var backgroundColor: Color {
        theme.darkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1)
    }
    
    private var selectedTextColor: Color {
        theme.darkMode ? Color.white : Color.black
    }
    
    private var unselectedTextColor: Color {
        theme.darkMode ? Color.white.opacity(0.6) : Color.black.opacity(0.6)
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $currentIndex) {
                ForEach(selections.indices, id: \.self) { index in
                    Text(selections[index])
                        .tag(index)
                        .foregroundColor(index == currentIndex ? selectedTextColor : unselectedTextColor)
                }
            }
            .pickerStyle(.segmented)
            .background(backgroundColor)
            .cornerRadius(8)
            .padding()
        }
    }
}

struct PreferencesView: View {
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var shopperModel: ShopperModel
    
    @State private var currentGenderIndex: Int = 0
    
    private var backgroundColor: Color {
        if (shopperModel.girlIsChecked) {
            return Color(UIColor(hex: theme.darkMode ? theme.darkA2 : theme.accentColor2)!).opacity(0.7)
        } else {
            return Color(UIColor(hex: theme.darkMode ? theme.darkA1 : theme.accentColor)!).opacity(0.7)
        }
    }
    
    func updateGenderSelection() {
        if currentGenderIndex == 0 {
            shopperModel.girlIsChecked = true
            shopperModel.boyIsChecked = false
        } else {
            shopperModel.boyIsChecked = true
            shopperModel.girlIsChecked = false
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { gp in
                ZStack {
                    Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!)
                        .ignoresSafeArea()
                    Circle()
                        .fill(backgroundColor)
                        .frame(width: gp.size.width * 1.5, height: gp.size.width * 1.5)
                        .position(x: gp.size.width / 2, y: gp.size.height / 4)
                        .shadow(radius: 5)
                    
                    Text("Your Preferences")
                        .bold()
                        .font(.title)
                        .foregroundColor(.white)
                        .position(x: gp.size.width / 2, y: gp.size.height / 4)
                        .offset(y: -gp.size.width / 4)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor(hex: theme.darkMode ? theme.darkC1 : theme.lightColor)!))
                        .frame(width: gp.size.width - 40, height: gp.size.height)
                        .offset(y: gp.size.height / 5)
                        .shadow(radius: 5)
                    
                    VStack (alignment: .leading) {
                        // Gender Picker
                        HStack {
                            Text("Gender")
                                .font(.system(size: 18))
                                .foregroundColor(Color(theme.darkMode ? .white : .black))
                                .frame(width: 100, alignment: .leading)
                                .padding(.leading)
                            
                            
                            CustomSegmentedView($currentGenderIndex, selections: ["Girl", "Boy"])
                                .onChange(of: currentGenderIndex) { _ in
                                    updateGenderSelection()
                                }
                        }
                        .padding(.top)
                        
                        // Age Picker
                        HStack {
                            Text("Age")
                                .font(.system(size: 18))
                                .foregroundColor(Color(theme.darkMode ? .white : .black))
                                .frame(width: 200, alignment: .leading)
                                .padding(.leading)
                            
                            Picker("Age Group", selection: Binding(
                                get: {
                                    if shopperModel.toddlerIsChecked { return Age.toddler }
                                    if shopperModel.childIsChecked { return Age.child }
                                    return Age.adolescent
                                },
                                set: { newValue in
                                    shopperModel.toddlerIsChecked = (newValue == .toddler)
                                    shopperModel.childIsChecked = (newValue == .child)
                                    shopperModel.adolescentIsChecked = (newValue == .adolescent)
                                }
                            )) {
                                ForEach(Age.allCases) { age in
                                    Text(age.rawValue.capitalized)
                                }
                            }
                            .accentColor(Color(UIColor(hex: shopperModel.girlIsChecked ? theme.accentColor2 : theme.accentColor)!))
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                        }
                        
                        Toggle("Dark Mode", isOn: $theme.darkMode)
                            .font(.system(size: 18))
                            .padding(.leading)
                            .frame(width: gp.size.width - 80)
                        
                        VStack {
                            Spacer()
                                .frame(height: 100)
                            NavigationLink {
                                BudgetManager()
                            } label: {
                                Text("Manage My Spending")
                                    .frame(width: 300, height: 30)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray).opacity(0.2))
                            }.padding(.horizontal)
                            
                            NavigationLink {
                                WebView()
                            } label: {
                                Text("Visit OCC Online")
                                    .frame(width: 300, height: 30)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray).opacity(0.2))
                            }.padding(.horizontal)
                            
                            NavigationLink {
                                PackingTipsView()
                            } label: {
                                Text("Get Packing Tips and Rules")
//                                    .foregroundColor(Color.blue)
                                    .frame(width: 300, height: 30)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray).opacity(0.2))
                            }.padding(.horizontal)
                        }.foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                    }
                    .padding(.top, 50)
                    .frame(width: gp.size.width - 60)
                    .foregroundColor(Color(theme.darkMode ? .white : .black))
                    
                }
            }
            .onAppear {
                updateGenderSelection()
            }
        }
    }
}

#Preview {
    PreferencesView()
        .environmentObject(Theme())
        .environmentObject(ShopperModel())
        .environmentObject(StepsViewModel())
        .environmentObject(TipsViewModel())
}
