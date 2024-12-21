//
//  OnboardingView.swift
//  OCC_iOSProj
//
//  Created by Ruby Greathouse on 11/9/24.
//

import SwiftUI

struct OnboardingViewDetails : View {
    @EnvironmentObject var theme: Theme
    var imageName: String
    var bgColor : Color
    var headline : String = ""
    var subHeadline : String = ""
    var buttonAction : () -> Void // place holder for an action
    var skipAction : () -> Void
    
    
    var body: some View {
        ZStack {
            Color(bgColor)
                .ignoresSafeArea()
            VStack {
                
                VStack {
                    Spacer()
                        .padding(.bottom, 100)
                    
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 500)
                    
                    Text(headline)
                        .font(Font.system(size: 22))
                        .bold()
                        .padding(.top)
                        .frame(height: 50)
                    
                    Text(subHeadline)
                        .padding(.horizontal)
                        .padding(.top, 4)
                    
                }.frame(height: 700)
                Spacer()
                    .frame(height: 50)
                
                Button {
                    buttonAction() // run the function
                } label:  {
                    ZStack {
                        Text("Next")
                            .font(.title3)
                            .foregroundColor(Color.white)
                            .frame(width: 300, height: 30)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color(UIColor(hex: theme.accentColor)!)))
                        
                    }
                }.padding(.horizontal)
                
                
                Button {
                    skipAction() // run the function
                } label:  {
                    ZStack {
                        Text("Skip")
                            .font(.title3)
                            .foregroundColor(Color.black)
                            .frame(width: 300, height: 30)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                    }
                }.padding(.horizontal)
                
                .padding(.bottom, 115)
            }.foregroundStyle(Color.black)
        }
    }
}


struct OnboardingView: View {

    @EnvironmentObject var theme: Theme
    @State var selectionIndex = 0
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
       
        ZStack {
            TabView(selection: $selectionIndex) {
                
                OnboardingViewDetails(imageName: "occ_logo", bgColor: Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!), headline: "Welcome to OCC Elf", subHeadline: "Your journey with OCC starts here!") {
                    // button action
                    withAnimation {
                        selectionIndex = 1
                    }
                } skipAction: {
                    dismiss()
                }
                .tag(0)
                
                OnboardingViewDetails(imageName: "box", bgColor: Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!), headline: "Get Gift Suggestions", subHeadline: "We're here to help you find the perfect gifts.") {
                    // button action
                    withAnimation {
                        selectionIndex = 2
                    }
                } skipAction: {
                    dismiss()
                }
                .tag(1)
                
                OnboardingViewDetails(imageName: "ncw", bgColor: Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!), headline: "Pack a Box", subHeadline: "Get ready for National Collection Week!") {
                    // button action
                    withAnimation {
                        dismiss()
                    }
                } skipAction: {
                    dismiss()
                }
                .tag(2)
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(Theme())
        .environmentObject(ShopperModel())
        .environmentObject(TipsViewModel())
}
