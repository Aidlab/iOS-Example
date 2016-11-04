# Introduction
This repository is dedicated for developers who want to understand how to build publicly distributed applications featuring Aidlab sensor integration. iOS-Example will guide you how to connect with Aidlab health tracker, so it will save your time and make real development faster and easier. 

You can check our [website](www.aidlab.com/developer) to get the answers for the most common questions related to Aidlab.

# Technical overview
iOS-Example was build with Swift 3.0, using Xcode 8.0 and is created on top of Apple's Core Bluetooth technology.

Connect with Aidlab to use sensors and collected data. You can ask the device for the readings listed bellow:

* Readings from ECG sensor
* Readings from object temperature sensor
* Readings from ambient temperature sensor
* Readings from respiration sensor
* Battery level
* USB connection status

# Events

**didConnectPeripheral**

```
func didConnectPeripheral()
```

This event is invoked right after establishing connection with Aidlab. Check your Bluetooth status if you have trouble communicating with Aidlab.

**didDisconnectPeripheral**

```
func didDisconnectPeripheral()
```

Similar event will be fired on Aidlab's disconnection.

**didReceiveTemperature**

```
func didReceiveTemperature( _ objectTemperature: Float, ambientTemperature: Float )
```

This event will be invoked to use temperature readings and to apply them in application. It shares Aidlab's data on object temperature from directional sensor and ambient temperature from built-in, hidden sensor.

**didReceiveRespiration**

```
func didReceiveRespiration( _ value: [Float] )
```

This way you get data from Aidlab's respiration sensor, which provides enough data to analyse and display a respiration rate graph.

**didReceiveECG**

```
func didReceiveECG( _ value: [Float] )
```

Aidlab uses similar function to receive constant ECG measurement, which will allow you to draw or analyze ECG signal.

**didReceiveBatteryStatus**

```
func didReceiveBatteryStatus( _ batteryStatus: BatteryStatus )

public struct BatteryStatus {
   ios-ex
   /// State of charge between 0.0 and 100.0
   var soc: Float
   
   /// Returns true if Aidlab is connected to power source through USB cable
   /// False otherwise
   var inCharge: Bool
}
```

Impotant part of Aidlab's usage is the battery status. You never want Aidlab to run low on battery, as it can lead to it's turn off. Use this event to inform your users about Aidlab's low energy.
