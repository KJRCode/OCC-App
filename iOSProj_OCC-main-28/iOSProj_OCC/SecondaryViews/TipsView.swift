//
//  TipsView.swift
//  iOSProj_OCC
//
//  Created by Karly Ripper on 12/5/24.
//

import SwiftUI

struct TipsView: View {
    @EnvironmentObject var tipList: TipsViewModel
    @EnvironmentObject var theme: Theme
    @Binding var index: Int
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!)
                    .ignoresSafeArea()
                
                VStack{
                    
                    Text(tipList.tips[index].header)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                    
                    ScrollView{
                        VStack(alignment: .leading, spacing: 20){
                            
                            Image("tips\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                            
                            Spacer()
                            let maxp1 = tipList.tips[index]
                            let maxp2 = maxp1.lists
                            ForEach(maxp2){ val in
                                HStack{
                                    Text(val.title)
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                                    
                                    Spacer()
                                    
                                    if val.website != nil{
                                        NavigationLink{
                                            WebView3(spURL: val.website!)
                                        }label:{
                                            Text("Buy Here")
                                                .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                                                .padding()
                                                .frame(width: 180, height: 30)
                                                .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.3))
                                        }
                                        
                                    }
                                }
                                
                                Text(val.description)
                                    .bold()
                                    .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                                
                                
                                
                                let v1 = val
                                let v2 = v1.info.count
                                ForEach(0 ..< v2, id: \.self){ i in
                                    HStack(spacing: 4){
                                                 
                                        VStack{
                                            Image(systemName: "circle.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 6, height: 6).padding(.leading, 7).padding(.horizontal, 5).padding(.top, 8).foregroundColor(Color(UIColor(hex: (i%2 == 0) ? theme.accentColor2 : theme.accentColor)!))
                                            Spacer()
                                        }
                                        VStack{
                                            Text(val.info[i])
                                                .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                        }.padding()
                    }//.padding(.all, 70)
                    
                }//.padding(.leading, 100).padding(.trailing, 200)
            }
        }
    }
}

#Preview {
    @State var index = 0
    TipsView(index: $index).environmentObject(TipsViewModel()).environmentObject(Theme())
}
