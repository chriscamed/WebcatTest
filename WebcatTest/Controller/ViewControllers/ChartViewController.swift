//
//  ChartViewController.swift
//  WebcatTest
//
//  Created by Camilo Medina on 4/16/17.
//  Copyright © 2017 webcat. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    var question: Question?
    var barTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = barTitle!
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.statusBarStyle = .default
        var votesArray: [Int] = []
        var titlesArray: [String] = []
        question!.choices.forEach { votesArray.append($0.votes) }
        question!.choices.forEach { titlesArray.append($0.name) }
        setChart(dataPoints: titlesArray, values: votesArray)
    }
    
    func setChart(dataPoints: [String], values: [Int]) {
        pieChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let percentage = Double(Double(values[i])/Double(values.total)*100)
            let dataEntry = PieChartDataEntry(value: percentage, label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "Votes per choice")
        chartDataSet.sliceSpace = 2.0
        
        var colors: [UIColor] = []
        colors.append(contentsOf: ChartColorTemplates.vordiplom())
        colors.append(contentsOf: ChartColorTemplates.joyful())
        colors.append(contentsOf: ChartColorTemplates.colorful())
        colors.append(contentsOf: ChartColorTemplates.liberty())
        colors.append(contentsOf: ChartColorTemplates.pastel())
        colors.append(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1.0))
        
        chartDataSet.colors = colors;
        
        chartDataSet.valueLinePart1OffsetPercentage = 0.8;
        chartDataSet.valueLinePart1Length = 0.4;
        chartDataSet.valueLinePart2Length = 0.6;
        //dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
        chartDataSet.yValuePosition = .outsideSlice;
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent;
        pFormatter.maximumFractionDigits = 1;
        pFormatter.multiplier = 1.0;
        pFormatter.percentSymbol = " %";
        
        chartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        chartData.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 11))
        chartData.setValueTextColor(UIColor.black)
        
        pieChartView.highlightValues(nil)
        
        pieChartView.data = chartData
        
        pieChartView.chartDescription?.text = "\(values.total) votes in total"
        pieChartView.setExtraOffsets(left:20.0, top:0.0, right:20.0, bottom:0.0)
        pieChartView.drawEntryLabelsEnabled = true
        pieChartView.drawHoleEnabled = true
        pieChartView.legend.enabled = true
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeInOutBack)
    }

}

extension Array where Element: Integer {
    /// Returns the sum of all elements in the array
    var total: Element {
        return reduce(0, +)
    }
}
extension Collection where Iterator.Element == Int, Index == Int {
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(reduce(0, +)) / Double(endIndex-startIndex)
    }
}
