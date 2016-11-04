//
//  AidlabPeripheralDelegate.swift
//  iOS-Example
//
//  Created by J Domaszewicz on 04.11.2016.
//  Copyright © 2016 Aidlab. MIT License.
//

public protocol AidlabPeripheralDelegate {
    
    func didConnectPeripheral()
    
    func didDisconnectPeripheral()
    
    func didReceiveTemperature( _ objectTemperature: Float, ambientTemperature: Float )
    
    func didReceiveECG( _ value: [Float] )
    
    func didReceiveRespiration( _ value: [Float] )
    
    func didReceiveBatteryStatus( _ batteryStatus: BatteryStatus )
}
