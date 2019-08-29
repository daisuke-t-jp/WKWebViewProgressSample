//
//  ViewController.swift
//  WKWebViewProgress
//
//  Created by Daisuke T on 2019/08/29.
//  Copyright © 2019 DaisukeT. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
  
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var progressView: UIProgressView!
  
  private var observation: NSKeyValueObservation?
  private var colroCnt = 0
  private let colorArray: [UIColor] = [
    .blue,
    .green,
    .yellow,
    .red,
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView.navigationDelegate = self
    webView.load(URLRequest(url: URL(string: "https://www.kantei.go.jp/")!))
    
    progressView.progressTintColor = colorArray[colroCnt]
    colroCnt = colroCnt + 1
    
    observation = webView.observe(\.estimatedProgress, options: .new){_, change in
      print("progress=\(String(describing: change.newValue))")
      self.progressView.setProgress(Float(change.newValue!), animated: true)
      
      if change.newValue! >= 1.0 {
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [.curveEaseIn],
                       animations: {
                        self.progressView.alpha = 0.0
                        
        }, completion: { (finished: Bool) in
          self.progressView.progressTintColor = self.colorArray[self.colroCnt]
          self.colroCnt = self.colroCnt + 1
          if self.colroCnt >= self.colorArray.count {
            self.colroCnt = 0
          }
          
          self.progressView.setProgress(0, animated: false)
        })
      }
      else {
        self.progressView.alpha = 1.0
      }
    }
    
  }
  
}


// MARK: - WKNavigationDelegate
extension ViewController {
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    print("didFinish")
  }
  
}

