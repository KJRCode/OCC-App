//
//  TipsSites.swift
//  iOSProj_OCC
//
//  Created by Karly Ripper on 12/5/24.
//

import SwiftUI

import WebKit

struct WebView3: UIViewRepresentable {
    var spURL: String
    
    func makeUIView(context: Context) -> WKWebView{
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context){
        if let url = URL(string: spURL){
            uiView.load(URLRequest(url: url))
        }else{
            uiView.load(URLRequest(url: URL(string: "https://samaritanspurse.org/operation-christmas-child/frequently-asked-questions/")!))
        }
    }
}

#Preview {
    @State var spURL: String = ""
    WebView3(spURL: spURL)
}
