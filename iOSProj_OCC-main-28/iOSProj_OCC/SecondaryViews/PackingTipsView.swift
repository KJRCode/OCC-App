//
//  PackingTipsView.swift
//  iOSProj_OCC
//
//  Created by Karly Ripper on 11/25/24.
//

import SwiftUI

struct PackingTipsView: View {
    @EnvironmentObject var tipList: TipsViewModel
    @EnvironmentObject var theme: Theme
    @State var tipsIndex: Int = 0
    @State var sheetOn : Bool = false
    
    private func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        if theme.darkMode {
            appearance.backgroundColor = UIColor(hex: theme.darkColor)
            appearance.titleTextAttributes = [.foregroundColor: UIColor(hex: theme.lightColor)!]
        } else {
            appearance.backgroundColor = UIColor(hex: theme.lightColor)
            appearance.titleTextAttributes = [.foregroundColor: UIColor(hex: theme.darkColor)!]
        }
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        
        NavigationStack{
            ZStack {
                Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!).ignoresSafeArea()
//                LinearGradient(gradient: Gradient(colors: [
//                    .white,
//                    .white,
//                    Color(UIColor(hex: theme.accentColor)!)
//                ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                VStack(spacing: 50){
                    
                    ForEach(0..<tipList.tips.count){ i in
                        Button{
                            sheetOn = true
                            tipsIndex = i
                        }label:{
                            ZStack{
//                                RoundedRectangle(cornerRadius: 15).fill(Color.gray).opacity(0.2)
//                                    .frame(width: 330, height: 80)
                                Text(tipList.tips[i].header + "   ")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.title)
                                    .frame(width: 300, height: 130)
                                    .padding()
                                    .background((i%2 == 0) ? .green.opacity(0.5) : .red.opacity(0.5)).cornerRadius(20)
                                    
                                    //.background(.gray.opacity(0.2)).cornerRadius(20)
                            }
                        }
                        
                    }
                }.sheet(isPresented: $sheetOn) {
                    TipsView(index: $tipsIndex)
                }.onAppear {
                    setNavigationBarAppearance()
                }
                .navigationTitle("Packing Tips and Rules")
                .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                .navigationBarTitleDisplayMode(.automatic)
            }
//            GeometryReader { gp in
//
//            }
        }
        
        
    }
}

struct tipsView: View{
    @EnvironmentObject var tipList: TipsViewModel
    @EnvironmentObject var theme: Theme
    
    var body: some View {
        VStack{
            Text("Packing Tips")
        }
    }
}

///
///
///
///
///

#Preview {
    PackingTipsView().environmentObject(TipsViewModel()).environmentObject(Theme())
        .environmentObject(TipsViewModel())
    
}
