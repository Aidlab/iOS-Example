//
//  PlotView.swift
//  IOS-Example
//
//  Created by Kuba Domaszewicz on 15.01.2018.
//  Copyright © 2020 Aidlab. All rights reserved.
//

import Foundation
import Plot

let samplesRange: Int = 500

class PlotView: UIPlotView, PlotViewDataSource {
    
    var data: [Float] = []
    
    func renderingPoints() -> [Point] {

        var output: [Point] = []
        
        /// Set X,Y
        for i in 0 ..< data.count {
            
            let x = (Double(i) / Double( data.count )) * Double(frame.width)
            output.append( Plot.Point(x: x, y: Double(data[i]) ) )
        }

        return output
    }
}
