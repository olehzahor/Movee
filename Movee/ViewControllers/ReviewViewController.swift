//
//  ReviewViewController.swift
//  Movee
//
//  Created by jjurlits on 3/15/21.
//

import UIKit
import WebKit

class ReviewViewController: UIViewController, Coordinated {
    weak var coordinator: MainCoordinator?
        
    var review: Review?
        
//    override func viewDidLoad() {
//        //let webView = WKWebView()
//        //view = webView
//
//        if let urlString = review?.viewModel.url,
//           let url = URL(string: urlString) {
//            print(url)
//
//            let css = ".a { color: black; } .content { font-family: -apple-system; padding: 16px;} @media (prefers-color-scheme: light) { body { color: black; } } @media (prefers-color-scheme: dark) { body { color: white; } .a { color: white } }"
//
//            let jscript =
//            """
//                document.getElementsByTagName('head')[0].innerHTML = ''
//                var meta = document.createElement('meta');
//                meta.setAttribute('name', 'viewport');
//                meta.setAttribute('content', 'width=device-width, initial-scale=1, shrink-to-fit=no');
//                document.getElementsByTagName('head')[0].appendChild(meta);
//
//                document.getElementById("footer").remove();
//                document.getElementsByClassName("new content sidebar no_logo")[0].remove();
//
//                reviewContainer = document.getElementsByClassName('content column pad')[0];
//                document.bgColor = 'transparent';
//
//                var style = document.createElement('style');
//                style.innerHTML = '\(css)';
//                document.head.appendChild(style);
//            """
//
//            let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//            let wkUController = WKUserContentController()
//            wkUController.addUserScript(userScript)
//            let wkWebConfig = WKWebViewConfiguration()
//            wkWebConfig.userContentController = wkUController
//            let webView = WKWebView(frame: view.bounds, configuration: wkWebConfig)
//            //view = webView
//            view.addSubview(webView)
//            webView.fillSuperview()
//            webView.load(URLRequest(url: url))
//            webView.backgroundColor = .clear
//            webView.scrollView.backgroundColor = .systemBackground
//            webView.isOpaque = false
//
//        }
//    }
//
    override func viewDidLoad() {
        let textView = UITextView()
        textView.isEditable = false
        textView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        view = textView
        textView.attributedText = review?.viewModel.attributedContent
    }
}
