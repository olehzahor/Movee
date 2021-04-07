//
//  WebViewController.swift
//  Movee
//
//  Created by jjurlits on 4/2/21.
//

import Foundation

import UIKit
import WebKit

class WebViewController: UIViewController {
    var url: URL?
    
    override func viewDidLoad() {
        guard let url = url else { return }
        
        let css = ".a { color: black; } .content { font-family: -apple-system; padding: 16px;} @media (prefers-color-scheme: light) { body { color: black; } } @media (prefers-color-scheme: dark) { body { color: white; } .a { color: white } }"
        
        let jscript =
            """
                document.getElementsByTagName('head')[0].innerHTML = ''
                var meta = document.createElement('meta');
                meta.setAttribute('name', 'viewport');
                meta.setAttribute('content', 'width=device-width, initial-scale=1, shrink-to-fit=no');
                document.getElementsByTagName('head')[0].appendChild(meta);

                document.getElementById("footer").remove();
                document.getElementsByClassName("new content sidebar no_logo")[0].remove();

                reviewContainer = document.getElementsByClassName('content column pad')[0];
                document.bgColor = 'transparent';

                var style = document.createElement('style');
                style.innerHTML = '\(css)';
                document.head.appendChild(style);
            """
        
        let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(userScript)
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        let webView = WKWebView(frame: view.bounds, configuration: wkWebConfig)
        view = webView
//        view.addSubview(webView)
//        webView.fillSuperview()
        webView.load(URLRequest(url: url))
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .systemBackground
        webView.isOpaque = false
    }
}
