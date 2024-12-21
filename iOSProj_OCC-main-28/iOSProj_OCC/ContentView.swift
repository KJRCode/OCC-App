//
//  ContentView.swift
//  COMP401FInalProject
//
//  Created by SarahSmalley on 11/8/24.
//
import SwiftUI

enum TabbedItems: Int, CaseIterable {
    case shopping
    case home = 2
    case preferences
    
    var title: String {
        switch self {
        case .shopping:
            return "Shopping"
        case .home:
            return "Home"
        case .preferences:
            return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .shopping:
            return "cart"
        case .home:
            return "house"
        case .preferences:
            return "gear"
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var GM: GameModel
    @EnvironmentObject var tips: TipsViewModel
    @State var initialVal: Double = 0.0
    @State var initialBudget: String = ""
    @State var amtSpentStr: String = ""
    @State var amtSpent: Double = 0.0
    
    @AppStorage("onboarding") var needsOnboarding = true
    
    @State var selectedTab = 2 // Default to "Home"
    
    @StateObject var shopperModel = ShopperModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!)
                    .ignoresSafeArea()
                
                TabView(selection: $selectedTab) {
                    withAnimation {
                        Shopping()
                            .tag(1)
                    }
                    
                    withAnimation {
                        HomeView()
                            .tag(2)
                    }
                    
                    withAnimation {
                        PreferencesView()
                            .tag(3)
                    }
                }
                
                // Custom tab bar
                ZStack {
                    HStack {
                        ForEach(TabbedItems.allCases, id: \.self) { item in
                            Button {
                              
                                selectedTab = item.rawValue
                            } label: {
                                CustomTabItem(imageName: item.iconName, title: item.title, isActive: selectedTab == item.rawValue)
                            }
                        }
                    }
                    .padding(6)
                }
                .frame(height: 70)
                .background(Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!))
                .cornerRadius(35)
                .padding(.horizontal, 26)
                .shadow(radius: 5)
                
            }.foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
            
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $needsOnboarding) {
                OnboardingView()
            }.onAppear {
               
                UINavigationBar.appearance().largeTitleTextAttributes = [
                    .foregroundColor: theme.darkMode ? UIColor.white : UIColor.black
                ]
                UINavigationBar.appearance().titleTextAttributes = [
                    .foregroundColor: theme.darkMode ? UIColor.white : UIColor.black
                ]
            }
        }
    }
}

extension ContentView {
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View {
        HStack(spacing: 10) {
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? (theme.darkMode ? .white : .black) : (theme.darkMode ? .gray : .gray))
                .frame(width: 20, height: 20)

            if isActive {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isActive ? (theme.darkMode ? .white : .black) : (theme.darkMode ? .gray : .gray))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(isActive ? (theme.darkMode ? Color.green.opacity(0.4) : Color.green.opacity(0.2)) : .clear)
        .cornerRadius(30)
    }
}

#Preview {
    ContentView()
        .environmentObject(ShopperModel())
        .environmentObject(Theme())
        .environmentObject(StepsViewModel())
        .environmentObject(TipsViewModel())
        .environmentObject(ShoppingViewModel())
        .environmentObject(GameModel())
}
