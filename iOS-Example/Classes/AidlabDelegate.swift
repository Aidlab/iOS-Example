//
//  AidlabDelegate.swift
//  iOS-Example
//
//  Created by J Domaszewicz on 04.11.2016.
//  Copyright © 2016 Aidlab. MIT License.
//

import Foundation

protocol AidlabDelegate: class {
    
    func didReceiveTemperature( _ objectTemperature: Float, ambientTemperature: Float )
    
    func didReceiveECG( _ values: [Float] )
    
    func didReceiveRespiration( _ values: [Float] )
    
    func didReceiveBatteryStatus( _ batteryStatus: BatteryStatus )
}
