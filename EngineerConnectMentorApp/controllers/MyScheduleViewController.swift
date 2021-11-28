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
    
    @IBOutlet weak var todayPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        todayPickerView.dataSource = self
        todayPickerView.delegate = self
        
        setTodayTimes()
        
    }
    
    func setTodayTimes() {
        let now = Date()
        print(now)
        var startTime = Calendar.current.date(byAdding: .minute, value: 30 - Calendar.current.component(.minute, from: now) % 30, to: now)
        print(startTime)
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
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        todayTimes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter.string(from: todayTimes[row])
    }
    
}

extension MyScheduleViewController: UIPickerViewDelegate {
    
}
