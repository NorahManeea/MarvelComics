//
//  WebViewController.swift
//  MarvelComicsV2
//
//  Created by Norah Almaneea on 18/05/2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var hero: Hero!

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    override func viewDidLoad() {
        //super.viewDidLoad()
        if !CheckInternet.Connection(){
            Alert.showBasicAlert(on: self, with: "WiFi is Turned Off", message: "Please turn on cellular data or use Wi-Fi to access data.")
        }else{
        let url = URL(string: hero.urls.first!.url)
        let request = URLRequest(url: url!)
        title = hero.name
        webView.navigationDelegate = self
        webView.load(request)

    }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }
}

