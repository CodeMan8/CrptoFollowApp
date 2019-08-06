//
//  ConverterController.swift
//  CryptoCurrency
//
//  Created by Bartu akman on 26.11.2018.
//  Copyright © 2018 Bartu akman. All rights reserved.
//

import UIKit

class ConverterController: UIViewController {
    
     // variables
    var myCurrency: [String] = []
    var myValues : [Double] = []
    var activeCurrency: Double = 0
    
    // UI outlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var output: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        activeCurrency = Double(ViewController.coins[0].priceUsd)!
        initiliaze()


     }
    func initiliaze(){
        
        for i in 0..<ViewController.coins.count {
            
            // Add coins
            
            myCurrency.append(ViewController.coins[i].name)
            myValues.append(Double(ViewController.coins[i].priceUsd)!)


        }
        
    }
   
    @IBAction func convert(_ sender: UIButton) {
        // Convert USD to our coins
        
        if  (input.text !=  "") {
            
            let coin =  Double(input.text!)!
            
        output.text = String(coin/activeCurrency) + "$"
            
        }
        else {
            alertError()
        }
    }
    
    func alertError(){
        // In order to alert user  the case which is any value being typed
        
        let alert = UIAlertController(title: "Error ", message: "Please type a number", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
     }
    
    

    

}

extension  ConverterController:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myCurrency[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return myCurrency.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = myValues[row]
    }
    
}

