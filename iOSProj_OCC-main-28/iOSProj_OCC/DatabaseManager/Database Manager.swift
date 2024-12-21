//
//  Database Manager.swift
//  iOSProj_OCC
//
//  Created by Karly Ripper on 12/10/24.
//

import Foundation
import SwiftUI
import SQLite

struct BoxItem: Identifiable{
    var id: Int
    var name: String = ""
    var quan: Int = 0
    var price: Double = 0.00
}

class DatabaseManager: ObservableObject{
    
    private var db: Connection?
    private var ItemTable : SQLite.Table?
    
    @Published var items = [BoxItem]()
    
    init(){
        createDatabase()
        resetData()
    }
    
    func resetData(){
        dropTables()
        createTables()
        items.removeAll()
    }
    
    private func createDatabase(){
        do{
            let documensDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
            let dbPath = documensDirectory.appendingPathComponent("SQLiteExp1.sqlite").path
            db = try Connection(dbPath)
            
            print("Succeed creating database")
        }catch{
            print(error)
        }
        
    }
    
    func createTables(){
        do{
            
            let iid = SQLite.Expression<Int>("id")
            let iname = SQLite.Expression<String>("name")
            let iquan = SQLite.Expression<Int>("quan")
            let iprice = SQLite.Expression<Double>("price")
            
            ItemTable = Table("item")
            
            try db?.run(ItemTable!.create(ifNotExists: true){ table in
                table.column(iid, primaryKey: .autoincrement)
                table.column(iname)
                table.column(iquan)
                table.column(iprice)
            })
            
            print("succeeded creating tables")
        }catch{
            print(error)
        }
        
    }
    
    func dropTables(){
        do{
            if ItemTable != nil{
                try db?.run(ItemTable!.drop(ifExists: true))
            }
            print("succeeed to drop tables")
        }catch{
            print(error)
        }
    }
    
    //add a new item to the table with the provided information
    func addItem(in_name: String, in_quan: Int, in_price: Double){
        do{
            if ItemTable != nil{
                let iname = SQLite.Expression<String>("name")
                let iquan = SQLite.Expression<Int>("quan")
                let iprice = SQLite.Expression<Double>("price")
                try db?.run(ItemTable!.insert(iname <- in_name, iquan <- in_quan, iprice <- in_price))
            }
        }catch{
            print(error)
        }
    }
    
    //fetch all items
    func fetchItems() -> [BoxItem]{
        var items : [BoxItem] = []
        do{
            if ItemTable != nil{
                for item in try db!.prepare(ItemTable!){
                    let iid = item[SQLite.Expression<Int>("id")]
                    let iname = item[SQLite.Expression<String>("name")]
                    let iquan = item[SQLite.Expression<Int>("quan")]
                    let iprice = item[SQLite.Expression<Double>("price")]
                    items.append(BoxItem(id: iid, name: iname, quan: iquan, price: iprice))
                }
            }
            
            self.items = items
            print("Succeeed and fetch \(items.count)")
        }catch{
            print(error)
        }
        
        return items
    }
    
    
    //delete any item with the provided name
    func deleteItem(name: String)->[Double]{
        var spentSub: [Double] = []
        
        do {
            
            if ItemTable != nil{
                for item in try db!.prepare(ItemTable!){
                    let iid = item[SQLite.Expression<Int>("id")]
                    let iname = item[SQLite.Expression<String>("name")]
                    let iquan = item[SQLite.Expression<Int>("quan")]
                    let iprice = item[SQLite.Expression<Double>("price")]
                    
                    if iname == name{
                        let item = ItemTable!.filter((SQLite.Expression<Int>("id") == iid))
                        try db?.run(item.delete())
                        spentSub.append(iprice * Double(iquan))
                    }
                }
            }
            
            print("succeeded deletion")
            
        }catch{
            print(error)
        }
        
        return spentSub
    }
    
}
