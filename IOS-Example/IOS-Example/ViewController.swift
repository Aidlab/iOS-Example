//
//  ViewController.swift
//  IOS-Example
//
//  Created by Szymon Gęsicki on 16/08/2020.
//  Copyright © 2020 Aidlab. All rights reserved.
//

import AidlabSDK
import UIKit
import CoreBluetooth

class ECGPlotView: PlotView {}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AidlabSDKDelegate, AidlabDelegate, AidlabSynchronizationDelegate {
    
    struct Value {

        var description: String
        var value: String
    }
    
    @IBOutlet weak var ecgPlotter: ECGPlotView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
            
        values["connection"] = Value(description: "Aidlab is connected", value: "false")
        values["skin_temperature"] = Value(description: "Skin temperature", value: "-- C")
        values["battery_soc"] = Value(description: "Battery state of charge", value: "--")
        values["ecg_samples"] = Value(description: "ECG samples", value: "\(x_1)")

        aidlabSDK = AidlabSDK(delegate: self)
        aidlabSDK?.scan()

        tableView.delegate = self
        tableView.dataSource = self

        ecgPlotter.dataSource = ecgPlotter

        timer = Timer.scheduledTimer(timeInterval: 1.0 / 30.0, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {

        if (UIApplication.shared.applicationState != .background) {

            ecgPlotter.render()

            if let connectionDate = connectionDate {

                if Date().timeIntervalSince(lastBaudRateUpdate) > 3 {

                    values["baud_rate"] = Value(description: "Baud rate (ECG samples/s)", value: "\(samplesPerSecond / 3)")
                    lastBaudRateUpdate = Date()
                    samplesPerSecond = 0
                }

                let elapsed = Date().timeIntervalSince(connectionDate)

                values["connection_date"] = Value(description: "Aidlab is connected for", value: "\(stringFromTimeInterval(interval: elapsed))")

                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "LabelCell")

        if(cell == nil) {

            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "LabelCell")
        }

        cell!.textLabel?.text = Array(values.values)[indexPath.row].value
        cell!.detailTextLabel?.text = Array(values.values)[indexPath.row].description

        return cell!
    }
    
    func didDiscover(_ aidlab: CBPeripheral) {

        let signals: [Signal] = [.battery, .activity, .steps, .orientation, .heartRate, .temperature, .motion, .ecg, .respiration]
        
        aidlabSDK?.stopScan()
        aidlabSDK?.connect(signals, peripheral: aidlab, aidlabDelegate: self)
    }
    
    func didDisconnect(_ aidlab: IAidlab) {
       
        x_1 = 0

        connectionDate = nil
        values["connection"] = Value(description: "Aidlab is connected", value: "false")
        tableView.reloadData()
        
        aidlabSDK?.scan()
    }
    
    func didConnect(_ aidlab: IAidlab) {
       
        connectionDate = Date()
        values["connection"] = Value(description: "Aidlab is connected", value: "true")
    }
    
    func didReceiveECG(_ aidlab: IAidlab, timestamp: UInt64, value: Float) {
        
        x_1 += 1
        samplesPerSecond += 1

        values["ecg_samples"] = Value(description: "ECG samples", value: "\(x_1)")
        ecgPlotter.data.append(value)
        if ecgPlotter.data.count > 2000 { ecgPlotter.data.remove(at: 0) }
    }
    
    func didReceiveBatteryLevel(_ aidlab: IAidlab, stateOfCharge: UInt8) {
       
        values["battery_soc"] = Value(description: "Battery state of charge", value: "\(stateOfCharge)%")
    }
    
    func didReceiveSkinTemperature(_ aidlab: IAidlab, timestamp: UInt64, value: Float) {
      
        values["skin_temperature"] = Value(description: "Skin temperature", value: "\(value) C")
    }
    
    func didReceiveRespiration(_ aidlab: IAidlab, timestamp: UInt64, value: Float) {}
    
    func didReceiveSteps(_ aidlab: IAidlab, timestamp: UInt64, value: UInt64) {}
    
    func didReceiveAccelerometer(_ aidlab: IAidlab, timestamp: UInt64, ax: Float, ay: Float, az: Float) {}
    
    func didReceiveGyroscope(_ aidlab: IAidlab, timestamp: UInt64, qx: Float, qy: Float, qz: Float) {}
    
    func didReceiveMagnetometer(_ aidlab: IAidlab, timestamp: UInt64, mx: Float, my: Float, mz: Float) {}
    
    func didReceiveQuaternion(_ aidlab: IAidlab, timestamp: UInt64, qw: Float, qx: Float, qy: Float, qz: Float) {}
    
    func didReceiveOrientation(_ aidlab: IAidlab, timestamp: UInt64, roll: Float, pitch: Float, yaw: Float) {}
    
    func didReceiveHeartRate(_ aidlab: IAidlab, timestamp: UInt64, hrv: [Int32], heartRate: Int32) {}
    
    func didReceiveRespirationRate(_ aidlab: IAidlab, timestamp: UInt64, value: UInt32) {}
    
    func didReceiveSoundVolume(_ aidlab: IAidlab, timestamp: UInt64, soundVolume: UInt16) {}
    
    func didDetect(_ aidlab: IAidlab, exercise: Exercise) {}
    
    func didDetect(_ aidlab: IAidlab, timestamp: UInt64, activity: ActivityType) { }
    
    func didReceiveError(_ aidlab: IAidlab, error: Error) {}
    
    func didReceiveRSSI(_ aidlab: IAidlab, rssi: Int32) {}
    
    func wearStateDidChange(_ aidlab: IAidlab, state: WearState) {}
    
    func didReceiveCommand(_ aidlab: IAidlab) {}
        
    func syncStateDidChange(_ aidlab: IAidlab, state: SyncState) {}
    
    func didReceivePastECG(_ aidlab: IAidlab, timestamp: UInt64, value: Float) { }
    
    func didReceivePastRespiration(_ aidlab: IAidlab, timestamp: UInt64, value: Float) { }
    
    func didReceivePastSkinTemperature(_ aidlab: IAidlab, timestamp: UInt64, value: Float) {}
    
    func didReceivePastHeartRate(_ aidlab: IAidlab, timestamp: UInt64, hrv: [Int32], heartRate: Int32) {}
    
    func didReceiveUnsynchronizedSize(_ aidlab: IAidlab, unsynchronizedSize: UInt16) {}
    
    func didReceivePastRespirationRate(_ aidlab: IAidlab, timestamp: UInt64, value: UInt32) {}
    
    func didReceivePastActivity(_ aidlab: IAidlab, timestamp: UInt64, activity: ActivityType) {}
    
    func didReceivePastSteps(_ aidlab: IAidlab, timestamp: UInt64, value: UInt64) {}
    
    private var aidlabSDK: AidlabSDK?
    private var values: [String: Value] = [:]
    
    private var timer: Timer!
    
    private var lastBaudRateUpdate = Date()
    private var samplesPerSecond = 0
    
    private var connectionDate: Date?

    /// Current sample's index of plot
    private var x_1: Int = 0
    
    private func stringFromTimeInterval(interval: TimeInterval) -> String {

        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

