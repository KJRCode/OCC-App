//
//  Shopping.swift
//  COMP401FInalProject
//
//  Created by SarahSmalley on 11/8/24.
//

import SwiftUI

struct Shopping: View {
    @State private var content = "Shopping in person"
    @State private var popUp1 = ""
    @State private var counter = 0
    @State var switchColors = false
    
    //@State var color = Color(.white)
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var SM: ShopperModel
    
    @EnvironmentObject var shoppingVM : ShoppingViewModel
    
    @State var online: Bool = false
    var hasTapped = false
    var body: some View {
        ZStack {
            Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!)
                .ignoresSafeArea()
            
            NavigationStack {
                let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: gridItems, spacing: 10) {
                    let color1 = CGFloat(arc4random())
                    let color2 = CGFloat(arc4random())
                    let color3 = CGFloat(arc4random())
                    ForEach(shoppingVM.categories) { cat in
                        var color = shoppingVM.getColor(for: cat.color).opacity(0.5)
                       
                        NavigationLink {
                            CategoryView(category: cat)
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 170, height: 125)
                                    .foregroundStyle(color)
                                Text(cat.name)
                                    .foregroundStyle(.white)
                                    .bold()
                            }
                            
                        }
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Toggle(isOn: $online, label: {
                        Text(content)
                            .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                    })
                }
                .frame(width: 340)
                .padding(.all)
                .onChange(of: online, initial: false){
                    if counter % 2 == 0{
                        content = "Shopping online"
                    } else {
                        content = "Shopping in-person"
                    }
                    counter += 1
                }
                
                let stores = SM.getStores(online: online)
                ForEach(0 ..< stores.count / 2) { index in
                    HStack {
                        StoreView(storeName: stores[index])
                        if stores.count > 2 {
                            StoreView(storeName: stores[index + 2])
                        }
                    }
                }
                VStack{
                    NavigationLink {
                        BudgetManager()
                    } label: {
                        Text("Manage My Spending")
                            .foregroundColor(Color.purple)
                            .frame(width: 315, height: 30)
                            .padding(.all)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray).opacity(0.3))
                        
                    }
                    
                    .padding(.bottom)
                    
                }
            }
            .navigationBarTitle("Shopping", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Shopping")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
            
        }
    }
}


struct CategoryView: View {
    var category: Category
    
    @State private var selectedTab: Int = 0
    
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var ShopperModel : ShopperModel
    
    @EnvironmentObject var shoppingVM : ShoppingViewModel
    
    var body: some View {
        
        ZStack (alignment: .top){
            
            TabView(selection: $selectedTab) {
                ScrollView {
                    VStack {
                        let contentToDisplay = ShopperModel.girlIsChecked ? category.contentGirl : category.contentBoy
                        ForEach(contentToDisplay, id: \.item) { itemName in
                            
                            Text("\(itemName.item)")
                                .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                                .frame(width: 300, height: 30)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(theme.darkMode ? Color(UIColor(hex: theme.darkC1)!) : Color.gray.opacity(0.2))
                                       
                                        
                                ).padding(.horizontal)
                            
                        }
                        
                    }
                }.tag(0)
                    .padding(.top, 130)
                
                VStack {
                    ForEach(category.doNotSend, id: \.item) { itemName in
                        
                        Text("\(itemName.item)")
                            .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                            .frame(width: 330, height: 30)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(theme.darkMode ? Color(UIColor(hex: theme.darkC1)!) : Color.gray.opacity(0.2))
                                    
                            )
                        
                    }
                    
                }.tag(1)
                
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            TabBarView(category: category, currentTab: $selectedTab)
        }
        .background(Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!))
        
        
    }
}

struct TabBarView: View {
    var category : Category
    @Binding var currentTab: Int
    @Namespace var namespace
    
    
    var tabBarOptions: [String] = ["Do Send", "Do Not Send"]
    
    
    @EnvironmentObject var shoppingVM : ShoppingViewModel
    
    @EnvironmentObject var theme: Theme
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false){
            HStack (spacing: 20) {
                ForEach(Array(zip(self.tabBarOptions.indices, self.tabBarOptions)),
                        id: \.0,
                        content: {
                    index, name in
                    TabBarItem(currentTab: self.$currentTab,
                               namespace: namespace.self,
                               tabBarItemName: name,
                               tab: index)
                })
            }
            .padding(.horizontal)
        }
        .padding(.horizontal, 100)
        .background(theme.darkMode ? shoppingVM.getColor(for: category.color).opacity(0.4) : shoppingVM.getColor(for: category.color).opacity(0.2))
        .frame(height: 180)
        .edgesIgnoringSafeArea(.all)
    }
}



struct TabBarItem: View {
    
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    
    var tabBarItemName: String
    var tab: Int
    
    @EnvironmentObject var theme: Theme
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Spacer()
                Text(tabBarItemName)
                    .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                if currentTab == tab {
                    Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!)
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(), value: currentTab)
        }
        .buttonStyle(.plain)
    }
}







struct StoreView: View {
    var storeName: String
    
    var body: some View {
        NavigationLink {
            WebView2(storeName: storeName)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 170, height: 125)
                    .foregroundStyle(.green.opacity(0.5))
                Text(storeName)
                    .foregroundStyle(.white)
                    .bold()
            }
        }
    }
}


#Preview {
    Shopping()
        .environmentObject(ShopperModel())
        .environmentObject(Theme())
        .environmentObject(ShoppingViewModel())
}
