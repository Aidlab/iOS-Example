//
//  CentralManager.swift
//  iOS-Example
//
//  Created by J Domaszewicz on 04.11.2016.
//  Copyright © 2016 Aidlab. All rights reserved.
//
//  To read a value from a BLE peripheral device (Aidlab), follow these steps:
//
//  1. Scan for avilable devices (scanForPeripheralsWithServices:nil)
//  2. On detecting a device, will get a call back to "didDiscoverPeripheral" delegate method.
//  3. Then establish a connection with detected BLE device (connectPeripheral)
//  4. On successful connection, request for all the services available in the BLE device (discoverServices)
//  5. Request all the characteristics available in each services (discoverCharacteristics)
//  6. Once we get the required characteristics detail, we need to subscribe to it, which lets the peripheral know we want the data it contains
//
//  NOTE: Connection will fail if user uses `Battery Saving` mode

import Foundation
import CoreBluetooth

let peripheralName = "Aidlab"

public class CentralManager: NSObject, CBCentralManagerDelegate, AidlabDelegate {
    
    public init( delegate: AidlabPeripheralDelegate ) {
        
        super.init()
        
        self.delegate = delegate
        
        _centralManager = CBCentralManager( delegate: self, queue: nil, options: nil )
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if #available(iOS 10.0, *) {
            if( central.state == CBManagerState.poweredOn ) {
                
                _centralManager.scanForPeripherals(withServices: nil, options: nil)
            }
        } else {
            if( central.state.rawValue == CBCentralManagerState.poweredOn.rawValue ) {
                
                _centralManager.scanForPeripherals(withServices: nil, options: nil)
            }
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        delegate.didDisconnectPeripheral()
        
        /// Try to connect again
        _centralManager.connect(peripheral, options: nil)
        
        if( error != nil ) {
            
            print("didDisconnectPeripheral: \(error)")
            
        } else if( peripheral.name == peripheralName ) {
            
            /// We've disconnected from Aidlab peripheral
        }
    }
    
    /// TODO: Handle situation when two Aidlabs will be visible
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if( peripheral.name == peripheralName ) {
            
            /// We want to store peripheral object in order to not lose
            /// reference to it (otherwise `didConnectPeripheral` will never fire)
            self.peripheral = peripheral
            
            _centralManager.connect(peripheral, options: nil)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        print("didFailToConnectPeripheral")
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        aidlabPeripheral = AidlabPeripheral(aidlabPeripheral: peripheral, aidlabDelegate: self)
        
        peripheral.discoverServices(nil)
        
        delegate.didConnectPeripheral()
    }
    
    //-- AidlabDelegate ----------------------------------------
    
    func didReceiveTemperature( _ objectTemperature: Float, ambientTemperature: Float ) {
        
        delegate.didReceiveTemperature( objectTemperature, ambientTemperature: ambientTemperature )
    }
    
    func didReceiveECG( _ values: [Float] ) {
        
        delegate.didReceiveECG( values )
    }
    
    func didReceiveRespiration( _ values: [Float] ) {
        
        delegate.didReceiveRespiration( values )
    }
    
    func didReceiveBatteryStatus( _ batteryStatus: BatteryStatus ) {
        
        delegate.didReceiveBatteryStatus( batteryStatus )
    }
    
    //-- Private ----------------------------------------
    
    fileprivate var delegate: AidlabPeripheralDelegate!
    
    fileprivate var aidlabPeripheral: AidlabPeripheral!
    
    fileprivate var peripheral: CBPeripheral!
    
    fileprivate var _centralManager: CBCentralManager!
}
