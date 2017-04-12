//
//  GluocoseViewController.swift
//  super_emr
//
//  Created by 王佳华 on 12/22/15.
//  Copyright (c) 2015 王佳华. All rights reserved.
//

import UIKit
import Charts
import Alamofire

class GluocoseViewController: UIViewController {

    let url = baseurl
    var gluocose:[Double]!
    var measure_datetime:[String]!
    
    @IBOutlet weak var ChartView: LineChartView!
    @IBOutlet weak var gluocoseValue: UITextField!
    @IBOutlet weak var meatureTime: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        meatureTime.text = getCurrentTime()
        setLineChart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLineChart(){
        Alamofire.request(.GET, self.url + "/Ajax/blood_gluocose/", parameters: nil)
            .validate()
            .responseJSON {response in
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                    self.gluocose = jsonData["gluocose"] as! [Double]
                    self.measure_datetime = jsonData["measure_datetime"] as! [String]
                    self.setChart(self.measure_datetime, values1: self.gluocose)
                }
    }
    
    func setChart(dataPoints: [String], values1: [Double]) {
        
        var dataEntries1: [ChartDataEntry] = []
        var dataEntries2: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry1 = ChartDataEntry(value: values1[i], xIndex: i)
            dataEntries1.append(dataEntry1)
//            let dataEntry2 = ChartDataEntry(value: values2[i], xIndex: i)
//            dataEntries2.append(dataEntry2)
        }
        
        let lineChartDataSet1 = LineChartDataSet(yVals: dataEntries1, label: "血糖值")
        lineChartDataSet1.setColor(UIColor.blueColor())// 显示颜色
        lineChartDataSet1.setCircleColor(UIColor.blueColor())// 圆形的颜色
        lineChartDataSet1.lineWidth = 2.0
        lineChartDataSet1.circleRadius = 5.0
        
//        let lineChartDataSet2 = LineChartDataSet(yVals: dataEntries2, label: "舒张压")
//        lineChartDataSet2.setColor(UIColor.greenColor())
//        lineChartDataSet2.setCircleColor(UIColor.greenColor())
//        lineChartDataSet2.lineWidth = 2.0
//        lineChartDataSet2.circleRadius = 5.0
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet1)
//        lineChartData.addDataSet(lineChartDataSet2)
        ChartView.data = lineChartData
        ChartView.descriptionText = "血糖趋势图"
        
    }
    
    func getCurrentTime()->String{
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss" //(格式可按自己需求修整)
        let strNowTime = timeFormatter.stringFromDate(date) as String
        return strNowTime
    }

    @IBAction func submitButtondown(sender: UIButton) {
        let params = ["glucose":self.gluocoseValue.text as String!,
            "demoInfo": "",
            "measure_datetime":self.meatureTime.text! as String]
        
        Alamofire.request(.GET, self.url + "/Ajax/blood_gluocose/", parameters: params)
            .validate()
            .responseJSON {response in
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                    let jsonerror = jsonData["error"] as! String
                    if jsonerror == "0"{
                        self.setLineChart()
                    }
                    else{
                        var alert = UIAlertView()
                        alert.title = "提交血糖数据"
                        alert.message = "血糖数据上传失败!"
                        alert.addButtonWithTitle("OK")
                        alert.show()
                    }
                self.meatureTime.text = self.getCurrentTime()
                self.gluocoseValue.text = ""
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
