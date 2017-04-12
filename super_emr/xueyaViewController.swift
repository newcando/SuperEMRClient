//
//  xueyaViewController.swift
//  super_emr
//
//  Created by 王佳华 on 10/15/16.
//  Copyright © 2016 王佳华. All rights reserved.
//

import UIKit
import Charts
import Alamofire

class xueyaViewController: UIViewController {
    
    let url = baseurl
//    var diastolic_pressure:[Double]!
//    var systolic_pressure:[Double]!
//    var measure_datetime:[String]!
    
    var diastolic_pressure = [Double]()
    var systolic_pressure = [Double]()
    var measure_datetime = [String]()
    
    var username = ""
    var user = 0
    
    @IBOutlet weak var ChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setLineChatr(){
        let parm = [
            "user" : self.user
        ]
        Alamofire.request(.GET, self.url + "/api/bloodpressure/", parameters: parm)
            .validate()
            .responseJSON {response in
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                let count = jsonData["count"] as! Int
                self.diastolic_pressure.removeAll()
                self.systolic_pressure.removeAll()
                self.measure_datetime.removeAll()
                for(var i = 0;i < count; i++){
                    self.diastolic_pressure.append(results[i]["diastolic_pressure"] as! Double)
                    self.systolic_pressure.append(results[i]["systolic_pressure"] as! Double)
                    self.measure_datetime.append(results[i]["measure_datetime"] as! String)
                    
                }
                self.setChart(self.measure_datetime, values1: self.systolic_pressure, values2: self.diastolic_pressure)
        }
    }
    func setChart(dataPoints: [String], values1: [Double], values2: [Double]) {
        
        var dataEntries1: [ChartDataEntry] = []
        var dataEntries2: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry1 = ChartDataEntry(value: values1[i], xIndex: i)
            dataEntries1.append(dataEntry1)
            let dataEntry2 = ChartDataEntry(value: values2[i], xIndex: i)
            dataEntries2.append(dataEntry2)
        }
        
        let lineChartDataSet1 = LineChartDataSet(yVals: dataEntries1, label: "收缩压")
        lineChartDataSet1.setColor(UIColor.blueColor())// 显示颜色
        lineChartDataSet1.setCircleColor(UIColor.blueColor())// 圆形的颜色
        lineChartDataSet1.lineWidth = 2.0
        lineChartDataSet1.circleRadius = 5.0
        
        let lineChartDataSet2 = LineChartDataSet(yVals: dataEntries2, label: "舒张压")
        lineChartDataSet2.setColor(UIColor.greenColor())
        lineChartDataSet2.setCircleColor(UIColor.greenColor())
        lineChartDataSet2.lineWidth = 2.0
        lineChartDataSet2.circleRadius = 5.0
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet1)
        lineChartData.addDataSet(lineChartDataSet2)
        ChartView.data = lineChartData
        ChartView.descriptionText = "血压趋势图"
        
    }
    
    func getCurrentTime()->String{
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss" //(格式可按自己需求修整)
        let strNowTime = timeFormatter.stringFromDate(date) as String
        return strNowTime
    }
    
    func getPatientID(){
        let parm = [
            "format" : "json",
            "user_type" : "A",
            "nickname" : self.username
        ]
        Alamofire.request(.GET, self.url + "/api/usersEx/", parameters: parm)
            .validate()
            .responseJSON {response in
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                self.user = results[0]["user"] as! Int
                print(self.user, terminator: "")
                self.setLineChatr()
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}