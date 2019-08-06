//
//  CryptoNewsController.swift
//  CryptoCurrency
//
//  Created by Bartu akman on 15.11.2018.
//  Copyright © 2018 Bartu akman. All rights reserved.
//

import UIKit

class CryptoNewsController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let link = "https://www.ccn.com"
        let url = URL(string: link)
        let urlRequest = URLRequest(url: url!)
        webView.loadRequest(urlRequest)
 
        // Do any additional setup after loading the view.
    }
    @IBAction func forward(_ sender: Any) {
        webView.goForward()
     }
    
    @IBAction func back(_ sender: Any) {
        webView.goBack()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        webView.stopLoading()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
