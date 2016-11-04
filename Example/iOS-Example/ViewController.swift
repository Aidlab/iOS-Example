//
//  ViewController.swift
//  iOS-Example
//
//  Created by J Domaszewicz on 04.11.2016.
//  Copyright © 2016 Aidlab. MIT License.
//

import UIKit
import iOS_Example

class ViewController: UIViewController, AidlabPeripheralDelegate {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        centralManager = CentralManager( delegate: self )
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    //-- AidlabPeripheralDelegate ----------------------------------------
    
    func didConnectPeripheral() {
        
        print("Did connect to Aidlab")
    }
    
    func didDisconnectPeripheral() {
        
        print("Lost connection to Aidlab")
    }
    
    func didReceiveTemperature( _ objectTemperature: Float, ambientTemperature: Float ) {
        
        print("Did receive temperature. Object: \(objectTemperature), ambient: \(ambientTemperature)")
    }
    
    func didReceiveECG( _ values: [Float] ) {
        
        /// Use those data to plot ECG signal
    }
    
    func didReceiveRespiration( _ values: [Float] ) {
        
        /// Use those data to plot respiration signal
    }
    
    func didReceiveBatteryStatus( _ batteryStatus: BatteryStatus ) {
        
        /// Use those data to warn user about low battery level.
    }
    
    //-- Private ----------------------------------------
    
    private var centralManager: CentralManager?
}

