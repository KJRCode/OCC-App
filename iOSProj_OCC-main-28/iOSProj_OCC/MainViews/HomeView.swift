//
//  HomeView.swift
//  iOSProj_OCC
//
//  Created by Ruby Greathouse on 11/12/24.
//
import SwiftUI

enum STATUS{
    case start, stop
}

class CountdownTimer: ObservableObject{
  
    @Published var daysRemaining: Int = 0
    @Published var hoursRemaining: Int = 0
    @Published var minutesRemaining: Int = 0
    @Published var secondsRemaining: Int = 0
    @Published var isTargetReached: Bool = false
    
    private var targetDate: Date
    var timer: Timer?
    
    init() {
        let now = Date()
        let calendar = Calendar.current
        
        
        var target = calendar.date(from: DateComponents(year: calendar.component(.year, from: now), month: 11, day: 18))!
        
        
        if now > target {
            target = calendar.date(byAdding: .year, value: 1, to: target)!
        }
        
        self.targetDate = target
        self.startTimer()
    }
    
    func startTimer() {
       
        updateTimeRemaining()
        
       
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateTimeRemaining()
        }
    }
    
    func updateTimeRemaining() {
        let now = Date()
        let calendar = Calendar.current
        
       
        if now > targetDate {
            let nextYearTarget = calendar.date(byAdding: .year, value: 1, to: targetDate)!
            targetDate = nextYearTarget
            self.isTargetReached = true
        } else {
            self.isTargetReached = false
        }
       
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: targetDate)
        
        
        self.daysRemaining = components.day ?? 0
        self.hoursRemaining = components.hour ?? 0
        self.minutesRemaining = components.minute ?? 0
        self.secondsRemaining = components.second ?? 0
    }
}

struct HomeView: View {
    @EnvironmentObject var theme: Theme
    @StateObject var timerCount: CountdownTimer = CountdownTimer()
    @State var shadowOn: Bool = false
    
    @State var s = ""
    
    @State var showMiniGame : Bool = false
    var body: some View {
        
        NavigationView{
            
            VStack(alignment: .leading){
                
//                VStack {
//                    Text("OCC Elf")
//                        .font(.custom("RibeyeMarrow-Regular", size: 45))
//                        .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
//                        .padding(.horizontal)
//                        .shadow(color: theme.darkMode ? .yellow : .green.opacity(0.5), radius: 2, x: 1, y: 1)
//                        .shadow(color: theme.darkMode ? .yellow : .green.opacity(0.5), radius: 2, x: -1, y: -1)
//
//                }.padding(.horizontal)
//
                    
                    
                
                ScrollView{
                    
                    VStack {
                       
                        Image("occ_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 375, height: 360)
                            .shadow(color: shadowOn ? (theme.darkMode ? .yellow.opacity(1) : .green.opacity(1)):  .green.opacity(0), radius: 15, x: 1, y: 1)
                            .onLongPressGesture {
                                showMiniGame = true
                                shadowOn = false
                                
                            }.sheet(isPresented: $showMiniGame) {
                                MiniGameView()
                            }
                            .onTapGesture{
                                shadowOn = true
                            }
                        
                        VStack{
                            Text("National Collection Week").font(.largeTitle).bold().padding().multilineTextAlignment(.center)
                            Text("Nov. 18 - 25th").font(.custom("Telegram", size: 28)).padding(.bottom).multilineTextAlignment(.center)
                            
                            if timerCount.isTargetReached {
                                Text("It's National Collection Week!!")
                                    .font(.title)
                                    .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                                    .padding(.bottom)
                            }
                            else {
                                HStack{
                                    
                                    VStack{
                                        
                                        Text("\(timerCount.daysRemaining)").foregroundStyle(.white).font(.custom("Times New Roman", size: 32)).bold()
                                        Text("Days").font(.custom("Times New Roman", size: 22)).bold().padding(.horizontal).foregroundStyle(.white)
                                    }
                                    Spacer()
                                    VStack{
                                        
                                        Text("\(timerCount.hoursRemaining)").foregroundStyle(.white).font(.custom("Times New Roman", size: 32)).bold()
                                        Text("Hrs").font(.custom("Times New Roman", size: 22)).bold().padding(.horizontal).foregroundStyle(.white)
                                    }
                                    Spacer()
                                    VStack{
                                        
                                        Text("\(timerCount.minutesRemaining)").foregroundStyle(.white).font(.custom("Times New Roman", size: 32)).bold()
                                        Text("Min").font(.custom("Times New Roman", size: 22)).bold().padding(.horizontal).foregroundStyle(.white)
                                    }
                                    Spacer()
                                    VStack{
                                        Text("\(timerCount.secondsRemaining)").foregroundStyle(.white).font(.custom("Times New Roman", size: 32)).bold()
                                        Text("Sec").font(.custom("Times New Roman", size: 22)).bold().padding(.horizontal).foregroundStyle(.white)
                                    }
                                }.padding().background(theme.darkMode ? Color(UIColor(hex: theme.accentColor)!) : Color(UIColor(hex: theme.accentColor)!)).cornerRadius(20)
                                
                            }
                        }
                        .padding().background(Color(UIColor(hex: theme.darkMode ? theme.darkC1 : theme.lightColor)!)).cornerRadius(20).shadow(color: Color(.gray), radius: 8).frame(width: 380)
                        
                        
                        
                        
                        Spacer()
                        Text("Samaritan's Purse sends Operation Christmas Child shoeboxes full of gifts to children around the world along with the gospel of Jesus Christ. \n\nOne of the easiest and most fun ways to get involved is to pack a shoebox for a child in need! Whether you are OCC veteran or a first time participent, we are here to help you pack the best packing experience possible. \n\nHere you will find packing rules, budgeting tips, and other resources to help you gift a child a shoebox and spread the wonderful word of the Lord this holiday season!")
                            .frame(width: 330)
                            .padding()
                            .lineSpacing(10)
                    }
                    .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
//                }
                
                //                VStack {
                NavigationLink(destination: StepsView()) {
                    VStack {
                        Text("Ready to pack a box?").bold()
                            .foregroundColor(theme.darkMode ? Color.white : Color(UIColor(hex: theme.accentColor2)!))
                        
                        
                        Text("Get Started")
                            .font(.title3)
                            .foregroundColor(Color.white)
                            .frame(width: 300, height: 30)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color(UIColor(hex: theme.accentColor)!)))
                    }.padding(.bottom)
                        .frame(maxWidth: .infinity)
                    
                }.padding(.bottom)
                
                
                .background(Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!))
            }
                
                
            }
            .navigationBarHidden(false)
            .background(Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!))
            .toolbar {
                            
                ToolbarItem(placement: .topBarLeading) {
                    VStack {
                        
                        Text("OCC Elf")
                            .font(.custom("RibeyeMarrow-Regular", size: 45))
                            .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                            .shadow(color: theme.darkMode ? .yellow : .green.opacity(0.5), radius: 2, x: 1, y: 1)
                            .shadow(color: theme.darkMode ? .yellow : .green.opacity(0.5), radius: 2, x: -1, y: -1)
                            .padding()
                      
                    }
                    
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        // end of navigation view
        
    }
}

#Preview {
    HomeView()
        .environmentObject(Theme())
        .environmentObject(StepsViewModel())
        .environmentObject(TipsViewModel())
}
