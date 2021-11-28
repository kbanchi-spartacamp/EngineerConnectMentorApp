//
//  MyScheduleViewController.swift
//  EngineerConnectMentorApp
//
//  Created by 伴地慶介 on 2021/11/26.
//

import UIKit
import AuthenticationServices
import Alamofire
import SwiftyJSON
import KeychainAccess
import PKHUD

class MyScheduleViewController: UIViewController {

    let consts = Constants.shared
    var alert = Alert()
    
    var todayTimes: [Date] = []
    var todaySchedule = ""
    
    var dayOfWeeks = ["日曜","月曜","火曜","水曜","木曜","金曜","土曜"]
    var dayOfWeek = ""
    
    var regularTimesStart: [Date] = []
    var regularTimesEnd: [Date] = []
    var regularScheduleStart = ""
    var regularScheduleEnd = ""
    
    @IBOutlet weak var todayPickerView: UIPickerView!
    @IBOutlet weak var dayOfWeekPickerView: UIPickerView!
    @IBOutlet weak var regularTimePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        todayPickerView.dataSource = self
        todayPickerView.delegate = self
        
        dayOfWeekPickerView.dataSource = self
        dayOfWeekPickerView.delegate = self
        
        regularTimePickerView.dataSource = self
        regularTimePickerView.delegate = self
        
        setTodayTimes()
        setRegularScheduleTimes()
        
    }
    
    func setTodayTimes() {
        let now = Date()
        let endTime = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: now), month: Calendar.current.component(.month, from: now), day: Calendar.current.component(.day, from: now),
            hour: 24, minute: 0, second: 0))
        var startTime = Calendar.current.date(byAdding: .minute, value: 30 - Calendar.current.component(.minute, from: now) % 30, to: now)
        while (startTime! < endTime!) {
            self.todayTimes.append(startTime!)
            startTime = Calendar.current.date(byAdding: .minute, value: 30, to: startTime!)
        }
    }
    
    func setRegularScheduleTimes() {
        let now = Date()
        let endTime = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: now), month: Calendar.current.component(.month, from: now), day: Calendar.current.component(.day, from: now),
            hour: 24, minute: 0, second: 0))
        var startTime = Calendar.current.date(byAdding: .minute, value: 30 - Calendar.current.component(.minute, from: now) % 30, to: now)
        while (startTime! < endTime!) {
            self.regularTimesStart.append(startTime!)
            startTime = Calendar.current.date(byAdding: .minute, value: 30, to: startTime!)
            self.regularTimesEnd.append(startTime!)
            startTime = Calendar.current.date(byAdding: .minute, value: 30, to: startTime!)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyScheduleViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.todayPickerView {
            return 1
        }
        if pickerView == self.dayOfWeekPickerView {
            return 1
        }
        if pickerView == self.regularTimePickerView {
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.todayPickerView {
            return todayTimes.count
        }
        if pickerView == self.dayOfWeekPickerView {
            return dayOfWeeks.count
        }
        if pickerView == self.regularTimePickerView {
            switch component {
            case 0:
                return regularTimesStart.count
            case 1:
                return regularTimesEnd.count
            default:
                return 0
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.todayPickerView {
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
            return formatter.string(from: todayTimes[row])
        }
        if pickerView == self.dayOfWeekPickerView {
            return dayOfWeeks[row]
        }
        if pickerView == self.regularTimePickerView {
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
            switch component {
            case 0:
                return formatter.string(from: regularTimesStart[row])
            case 1:
                return formatter.string(from: regularTimesEnd[row])
            default:
                return ""
            }
        }
        return ""
    }
    
}

extension MyScheduleViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
        if pickerView == self.todayPickerView {
            todaySchedule = formatter.string(from: todayTimes[row])
        }
        if pickerView == self.dayOfWeekPickerView {
            dayOfWeek = dayOfWeeks[row]
        }
        if pickerView == self.regularTimePickerView {
            regularScheduleStart = formatter.string(from: regularTimesStart[row])
            regularScheduleEnd = formatter.string(from: regularTimesEnd[row])
        }
    }
}
