import SwiftUI

class Log: ObservableObject {
    @Published var spent: Double = 0.0
    let pricer = NumberFormatter()
    let quantifier = NumberFormatter()
    @ObservedObject var dbService = DatabaseManager()
    
    func addItem(name: String, quantity: String, price: String){
        
        pricer.numberStyle = .decimal
        quantifier.numberStyle = .decimal
        
        spent += (pricer.number(from: price)?.doubleValue ?? 0.0) * (quantifier.number(from: quantity)?.doubleValue ?? 0.0)
        
        dbService.addItem(in_name: name, in_quan: (quantifier.number(from: quantity)?.intValue ?? 0), in_price: (pricer.number(from: price)?.doubleValue ?? 0.0))
        dbService.fetchItems()
    }
    
    func resetItems(){
        dbService.fetchItems()
        spent = 0.0
    }
    
    func deleteItem(item: String){
        
        var spentSub = dbService.deleteItem(name: item)
        for s in spentSub{
            spent -= s
        }
        
    }
}


struct BudgetManagerInfo: View {
    @EnvironmentObject var theme: Theme
    var body: some View {
        ZStack {
            Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!)
                .ignoresSafeArea()
            GeometryReader { gp in
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: 50)
                    
                    Text("Welcome to the Budget Manager!")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 20)
                    
                    Text("Use our built-in Budget Manager to keep track of what you buy and stick to a self-set spending limit. Log what you buy by entering a unique item name, the number of units you are buying, and the price of a single unit. \n\nWe recommend spending about $20.00-$35.00 on gifts per box. Note that there is a required $10.00 donation per box (not included in the estimate above). Remember to include this charge in your log.")
                        .multilineTextAlignment(.leading)
                        .lineSpacing(10)
                    
                }
                .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                .frame(width: gp.size.width - 60, alignment: .leading)
                .padding(20)
            }
        }
    }
}

#Preview {
    BudgetManagerInfo()
        .environmentObject(Theme())
}



struct BudgetManager: View {
    @State var spent: Double = 0.0
    @State var limit: Double = 0.0
    @State var boxNum: Int = 0
    @State var name_str = ""
    @State var quantity_str = ""
    @State var price_str = ""
    @State var deleteName = ""
    @ObservedObject var log: Log = Log()
    @State var sheetOn : Bool = false
    @EnvironmentObject var theme: Theme
    
    @AppStorage("hasShowBudgetManagerInfo") private var hasShownBudgetManagerInfo: Bool = false
    
   
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
        ZStack {
            Color(UIColor(hex: theme.darkMode ? theme.darkColor : theme.lightColor)!)
                .ignoresSafeArea()
            
            NavigationStack {
                VStack {
                    ScrollView {
                        
                        // Budget string
                        let limit_str = Binding<String>(
                            get : {
                                String(format: "%0.2f", limit)
                            },
                            set : {
                                self.limit = Double(atoi($0))
                            }
                        )
                        Spacer()
                            .frame(height: 40)
                        // User input budget
                        
                        VStack (alignment: .leading){
                            if limit == 0 {
                                Text("Enter a budget to see spending progress.")
                                    .padding(.bottom)
                            }
                            
                            HStack{
                                Text("Max Budget:").font(.title).bold()
                                TextField("Spending Limit", text: limit_str)
                                    .onChange(of: limit, perform: {newValue in limit = newValue})
                                    .textFieldStyle(.plain)
                                    .keyboardType(.numberPad)
                                    .font(.largeTitle)
                                    .multilineTextAlignment(.trailing)
                            }
                            
                            // Show total amount spent
                            HStack{
                                Text("Total Spent:").font(.title).bold()
                                Spacer()
                                Text("\(String(format: "%0.2f", log.spent))")
                                    .font(.largeTitle)
                                    .multilineTextAlignment(.trailing)
                            }
                            
                            if limit > 0 {
                                VStack {
                                    ProgressView("Spending Progress", value: log.spent / limit)
                                        .progressViewStyle(LinearProgressViewStyle())
                                        .frame(height: 60)
                                        .accentColor(log.spent >= limit ? Color(UIColor(hex: theme.accentColor2)!) : Color(UIColor(hex: theme.accentColor)!))
                                    Text(String(format: "%.0f%%", (log.spent/limit) * 100))
                                        .font(.headline)
                                        .padding(.top, 5)
                                }.padding(.bottom, 40).padding(.top, 20)
                            }
                            
                            // Notify user if they've gone over their limit
                            if log.spent > limit && limit != 0 {
                                Text("You have hit your spending limit. \nPlease review your purchases and adjust your budget accordingly.")
                                    .foregroundColor(Color.purple)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 20).padding(.horizontal, 50)
                            }
                        }
                        .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                        .padding(.horizontal)
                        
                        
                        
                        // Input fields and buttons
                        VStack {
                            HStack(){
                                ZStack(alignment: .center){
                                    if name_str.isEmpty{
                                        Text("Name").foregroundColor(.gray).opacity(0.5)
                                            .multilineTextAlignment(.leading)
                                            .frame(width: 100)
                                    }
                                    TextField("", text: $name_str)
                                        .textFieldStyle(.plain)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .frame(width: 100)
                                }
                                
                                
                                ZStack(alignment: .center){
                                    if quantity_str.isEmpty{
                                        Text("Quantity").foregroundColor(.gray).opacity(0.5)
                                            .multilineTextAlignment(.center)
                                            .frame(width: 100)
                                    }
                                    TextField("", text: $quantity_str)
                                        .textFieldStyle(.plain)
                                        .multilineTextAlignment(.center)
                                        .keyboardType(.numberPad)
                                        .frame(width: 100)
                                }
                                
                                
                                ZStack(alignment: .center){
                                    if price_str.isEmpty{
                                        Text("Price").foregroundColor(.gray).opacity(0.5)
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: 100)
                                    }
                                    TextField("", text: $price_str)
                                        .textFieldStyle(.plain)
                                        .multilineTextAlignment(.center)
                                        .keyboardType(.numberPad)
                                        .frame(width: 100)
                                }.frame(width: 100)
                                
                            }
                            
                            .padding()
                            
                            Button {
                                if !price_str.isEmpty && !quantity_str.isEmpty && !name_str.isEmpty {
                                    log.addItem(name: name_str, quantity: quantity_str, price: price_str)
                                }
                                price_str = ""
                                quantity_str = ""
                                name_str = ""
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(UIColor(hex: theme.accentColor)!))
                                    Text("Add Item")
                                        .foregroundColor(.white)
                                        .bold()
                                        .padding()
                                }
                            }
                            
                            Button {
                                log.dbService.resetData()
                                log.resetItems()
                                deleteName = " "
                                deleteName = ""
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.blue)
                                    Text("Clear Items")
                                        .foregroundColor(.white)
                                        .bold()
                                        .padding()
                                }
                            }
                            
                            Divider()
                            
                            HStack {
                                
                                ZStack(alignment: .center){
                                    if deleteName.isEmpty{
                                        Text("Name").foregroundColor(.gray).opacity(0.5)
                                            .frame(width: 130)
                                    }
                                    TextField("", text: $deleteName)
                                        .textFieldStyle(.plain)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .frame(width: 130)
                                }
                                
                                
                                Button {
                                    log.deleteItem(item: deleteName)
                                    log.dbService.fetchItems()
                                    deleteName = " "
                                    deleteName = ""
                                } label: {
                                    ZStack {
                                        
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color(UIColor(hex: theme.accentColor2)!))
                                        Text("Delete Item")
                                            .foregroundColor(.white)
                                            .bold()
                                            .padding()
                                    }.padding(.leading, 40)
                                }
                            }.frame(height: 50)
                            
                            Divider()
                            
                            ForEach(log.dbService.items) { index in
                                VStack {
                                    HStack {
                                        Text(index.name).bold().multilineTextAlignment(.leading)
                                            .frame(width: 100)
                                        
                                        Text("\(index.quan)").multilineTextAlignment(.center)
                                            .frame(width: 100)
                                        
                                        Text("\(String(format: "%0.2f", index.price))").multilineTextAlignment(.trailing)
                                            .frame(width: 100)
                                    }
                                }
                            }
                            
                        }.foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                            .padding()
                            .background(Color(UIColor(hex: theme.darkMode ? theme.darkC1 : theme.lightColor)!))
                            .cornerRadius(20)
                            .shadow(color: Color.gray, radius: 8)
        
                            .padding(.horizontal)
                    }
                }
                .sheet(isPresented: $sheetOn, content: {
                    BudgetManagerInfo()
                })
                .onAppear {
                    setNavigationBarAppearance()
                    if !hasShownBudgetManagerInfo {
                        sheetOn = true
                        hasShownBudgetManagerInfo = true
                    }
                }
                .navigationTitle("Budget Manager")
                .foregroundColor(Color(UIColor(hex: theme.darkMode ? theme.lightColor : theme.darkColor)!))
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            sheetOn = true
                        } label: {
                            Image(systemName: "questionmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(UIColor(hex: theme.accentColor2)!))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BudgetManager().environmentObject(Theme())
        .environmentObject(TipsViewModel())
}
