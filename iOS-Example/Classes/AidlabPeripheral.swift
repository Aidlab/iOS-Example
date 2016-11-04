//
//  AidlabPeripheral.swift
//  iOS-Example
//
//  Created by J Domaszewicz on 31.05.2016.
//  Copyright © 2016 Aidlab. MIT License.
//

import Foundation
import CoreBluetooth

let temperatureCharacteristicUUID = CBUUID(string: "45366E80-CF3A-11E1-9AB4-0002A5D5C51B")
let ecgCharacteristicUUID = CBUUID(string: "46366E80-CF3A-11E1-9AB4-0002A5D5C51B")
let batteryCharacteristicUUID = CBUUID(string: "47366E80-CF3A-11E1-9AB4-0002A5D5C51B")
let respirationCharacteristicUUID = CBUUID(string: "48366E80-CF3A-11E1-9AB4-0002A5D5C51B")

let characteristics = [temperatureCharacteristicUUID, batteryCharacteristicUUID, ecgCharacteristicUUID, respirationCharacteristicUUID]

public struct BatteryStatus {
    
    /// State of Charge.
    var soc: Float
    
    /// Returns true if Aidlab is connected to power source through USB cable
    /// False otherwise
    var inCharge: Bool
}

class AidlabPeripheral: NSObject, CBPeripheralDelegate {
    
    init( aidlabPeripheral: CBPeripheral, aidlabDelegate: AidlabDelegate ) {
        
        super.init()
        
        self.aidlabDelegate = aidlabDelegate
        
        aidlabPeripheral.delegate = self
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
    
        if( error != nil) {
            
            print( "Error: \(error?.localizedDescription)")
        }
        
        for characteristic in service.characteristics! {
            
            print( characteristic )
            /// We assume that all of characteristics are notifiable
            if( characteristics.contains( characteristic.uuid ) ) {
                
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
        if (error != nil) {
            
            print("\(characteristic.uuid) Error changing notification state: \(error!.localizedDescription)")
            
            return
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if (error != nil) {
            
            print("Error reading characteristics: \(error!.localizedDescription)")
            
        } else {
            
            if let value = characteristic.value {
                
                if( characteristic.uuid == temperatureCharacteristicUUID ) {
                    
                    let temperatures = calculateTemperatureValue( value )
                    
                    aidlabDelegate.didReceiveTemperature( temperatures.objectTemperature, ambientTemperature: temperatures.ambientTemperature )
                    
                } else if( characteristic.uuid == ecgCharacteristicUUID ) {
                    
                    aidlabDelegate.didReceiveECG( calculateECGValue( value ) )
                    
                } else if( characteristic.uuid == respirationCharacteristicUUID ) {
                    
                    aidlabDelegate.didReceiveRespiration( calculateECGValue( value ) )
                    
                } else if( characteristic.uuid == batteryCharacteristicUUID) {
                    
                    aidlabDelegate.didReceiveBatteryStatus( calculateBatterySOCValue( value ) )
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    //-- Private ----------------------------------------
    
    private weak var aidlabDelegate: AidlabDelegate!
    
    private func calculateECGValue( _ value: Foundation.Data ) -> [Float] {
        
        let bytesRecieved: Int = 18
        let bytesPerSample: Int = 3
        
        var scratchVal: [UInt8] = Array(repeating: 0, count: bytesRecieved)
        (value as NSData).getBytes(&scratchVal, length: value.count)
        
        var ecgValues: [Float] = []
        
        for i in 0 ..< bytesRecieved / bytesPerSample {
            
            var ecgValue = Float(toU2(
                Int(scratchVal[i*bytesPerSample + 2]),
                byteB: Int(scratchVal[i*bytesPerSample + 1]),
                byteC: Int(scratchVal[i*bytesPerSample    ])
            ))
            
            /// Transform samples to Volts
            ecgValue /= pow(2,23)
            ecgValue *= 2.42
            
            ecgValues.append( ecgValue )
        }
        
        return ecgValues
    }
    
    private func calculateTemperatureValue( _ value: Data ) -> (objectTemperature: Float, ambientTemperature: Float) {
        
        var scratchVal: [UInt8] = Array(repeating: 0, count: 4)
        (value as NSData).getBytes(&scratchVal, length: value.count)
        
        var Tobj: Float = Float( Int(scratchVal[1]) << 8 | Int(scratchVal[0]) )
        Tobj *= 0.02
        Tobj -= 273.15
        
        var Tamb: Float = Float( Int(scratchVal[3]) << 8 | Int(scratchVal[2]) )
        Tamb *= 0.02
        Tamb -= 273.15
        
        return (Tobj, Tamb)
    }
    
    private func calculateBatterySOCValue( _ value: Data ) -> BatteryStatus {
        
        var scratchVal: [UInt8] = Array(repeating: 0, count: 3)
        (value as NSData).getBytes(&scratchVal, length: value.count)
        
        let soc = Float( Int(scratchVal[1]) << 8 | Int(scratchVal[0]) ) / 512.0
        let inCharge: Bool = scratchVal[2] == 0 ? false : true
        
        return BatteryStatus(soc: soc, inCharge: inCharge)
    }
}
