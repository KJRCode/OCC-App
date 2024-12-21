//
//  OfficialWebsite.swift
//  COMP401FInalProject
//
//  Created by SarahSmalley on 11/8/24.
//

import SwiftUI

import WebKit

struct WebView: UIViewRepresentable {
    
   
    var urlString : String { "https://samaritanspurse.org/operation-christmas-child/pack-a-shoe-box"
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
    WebView()
        
}
