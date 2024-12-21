//
//  StoreSites.swift
//  COMP401FInalProject
//
//  Created by SarahSmalley on 11/8/24.
//

import SwiftUI

import WebKit

struct WebView2: UIViewRepresentable {
    var storeName: String
    var urlString : String { "https://\(storeName).com"
    }
    
    func makeUIView(context: Context) -> WKWebView{
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context){
        
        if let url = URL(string: urlString){
            uiView.load(URLRequest(url: url))
        }else{
            uiView.load(URLRequest(url: URL(string: "https://www.google.com")!))
        }
        
    }
}
#Preview {
    @State var storeName: String = ""
    WebView2(storeName: storeName)
}
