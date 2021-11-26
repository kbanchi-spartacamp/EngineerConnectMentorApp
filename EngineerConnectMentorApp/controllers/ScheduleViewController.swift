//
//  ScheduleViewController.swift
//  EngineerConnectMentorApp
//
//  Created by 伴地慶介 on 2021/11/19.
//

import UIKit
import AuthenticationServices
import Alamofire
import SwiftyJSON
import KeychainAccess
import PKHUD

class ScheduleViewController: UIViewController {

    let consts = Constants.shared
    var reservations:[Reservation] = []
    var alert = Alert()
    
    @IBOutlet weak var reservationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        reservationTableView.dataSource = self
        
        getReservationsInfo()
    }
    
    func getReservationsInfo() {
        HUD.show(.progress)
        let keychain = Keychain(service: consts.service)
        guard let accessToken = keychain["access_token"] else { return }
        guard let mentor_id = keychain["mentor_id"] else { return }
        let url = URL(string: consts.baseUrl + "/reservations?mentor_id=" + mentor_id)!
        let headers: HTTPHeaders = [
            .authorization(bearerToken: accessToken)
        ]
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
                // success
            case .success(let value):
                self.reservations = []
                let json = JSON(value).arrayValue
                for reservations in json {
                    let user = User(
                        id: reservations["user"]["id"].int!,
                        name: reservations["user"]["name"].string!,
                        email: reservations["user"]["email"].string!,
                        profile_photo_url: reservations["user"]["profile_photo_url"].string ?? ""
                    )
                    let mentor = Mentor(
                        id: reservations["mentor"]["id"].int!,
                        name: reservations["mentor"]["name"].string!,
                        email: reservations["mentor"]["email"].string!,
                        profile: reservations["mentor"]["profile"].string ?? "",
                        profile_photo_url: reservations["mentor"]["profile_photo_url"].string ?? ""
                    )
                    let reservation = Reservation(
                        id: reservations["id"].int!,
                        user_id: reservations["user_id"].int!,
                        mentor_id: reservations["mentor_id"].int!,
                        day: reservations["day"].string ?? "",
                        start_time: reservations["start_time"].string ?? "",
                        user: user,
                        mentor: mentor
                    )
                    self.reservations.append(reservation)
                }
                print(self.reservations)
                self.reservationTableView.reloadData()
                HUD.hide()
                if self.reservations.isEmpty {
                    self.alert.showAlert(title: "No Reservation", messaage: "you have no reservation", viewController: self)
                }
                // fail
            case .failure(let err):
                HUD.hide()
                print(err.localizedDescription)
            }
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

extension ScheduleViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reservations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = reservations[indexPath.row].user.name + " : " + reservations[indexPath.row].start_time
        return cell
    }
    
}
