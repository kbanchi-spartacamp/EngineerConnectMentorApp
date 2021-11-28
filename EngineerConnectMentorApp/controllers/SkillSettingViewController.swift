//
//  SkillSettingViewController.swift
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

class SkillSettingViewController: UIViewController {

    let consts = Constants.shared
    var mentor_skills: [MentorSkill] = []
    var alert = Alert()
    
    @IBOutlet weak var skillTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        skillTableView.dataSource = self
        
        getMentorSkillInfo()
    }
    
    func getMentorSkillInfo() {
        HUD.show(.progress)
        let keychain = Keychain(service: consts.service)
        guard let accessToken = keychain["access_token"] else { return }
        guard let mentor_id = keychain["mentor_id"] else { return }
        let url = URL(string: consts.baseUrl + "/mentors/" + mentor_id + "/mentor_skills")!
        let headers: HTTPHeaders = [
            .authorization(bearerToken: accessToken)
        ]
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
                // success
            case .success(let value):
                self.mentor_skills = []
                let json = JSON(value).arrayValue
                for mentor_skills in json {
                    let skill_category = SkillCategory(
                        id: mentor_skills["skill_category"]["id"].int!,
                        name: mentor_skills["skill_category"]["name"].string!
                    )
                    let mentor_skill = MentorSkill(
                        id: mentor_skills["id"].int!,
                        mentor_id: mentor_skills["mentor_id"].int!,
                        skill_category_id: mentor_skills["skill_category_id"].int!,
                        experience_year: mentor_skills["experience_year"].int!,
                        skill_category: skill_category
                    )
                    self.mentor_skills.append(mentor_skill)
                }
                self.skillTableView.reloadData()
                HUD.hide()
                if self.mentor_skills.isEmpty {
                    self.alert.showAlert(title: "No Skill", messaage: "you have no skill", viewController: self)
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

extension SkillSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentor_skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let skillLabel = cell.viewWithTag(1) as! UILabel
        skillLabel.text = mentor_skills[indexPath.row].skill_category.name
        let yearLabel = cell.viewWithTag(2) as! UILabel
        yearLabel.text = String(mentor_skills[indexPath.row].experience_year) + "年"
        return cell
    }
        
}
