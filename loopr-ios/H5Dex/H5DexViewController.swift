//
//  H5DexViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/13/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import JavaScriptCore

class H5DexViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate {

    var webView: WKWebView!

    var start = Date()
    var end = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        createWebView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createWebView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "nativeCallbackHandler")
        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), configuration: config)

        let url = URL(string: "https://loopring.io/h5dex/#/")
        let request = URLRequest(url: url!)
        webView.load(request)
        
        self.view.addSubview(webView)
        
        // Auto Layout
        let topConst = NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: UIApplication.shared.statusBarFrame.height)
        let botConst = NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let leftConst = NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let rigthConst = NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([topConst, botConst, leftConst, rigthConst])
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        start = Date()
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // start = Date()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url")
        end = Date()
        let timeInterval: Double = end.timeIntervalSince(start)
        print("Time to _keystore: \(timeInterval) seconds")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("userContentController didReceive message")
        if message.name == "nativeCallbackHandler" {
            print(message.body)
        }
    }

}
