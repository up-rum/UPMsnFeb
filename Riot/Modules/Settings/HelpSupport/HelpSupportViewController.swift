// 
// Copyright 2022 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import SafariServices

class HelpSupportViewController: UIViewController {


    var supportOptions = ["Help and support", "Version", "App Settings"]
    var supportDetail = [String]()
    @IBOutlet weak var helpTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Help & About"
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        supportDetail.append("Get help with using UP Messenger")
        supportDetail.append("Version \(appVersion ?? "")")
        supportDetail.append("Show the application info in system settings")
//        helpTableView.register(UINib(nibName: "HelpSupportTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
//        helpTableView.tableFooterView = UIView()
        helpTableView.dataSource = self
        helpTableView.delegate = self
    }

}


extension HelpSupportViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        supportOptions[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?
                else {
                    fatalError( "should be registered")
                }

        cell.textLabel?.text = supportDetail[indexPath.section]
        if indexPath.section != 1 {
            cell.accessoryType = .disclosureIndicator

        }
//        cell.cellTitle?.text = supportOptions[indexPath.row]
//        cell.cellDetail?.text = supportDetail[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            guard let helpURL = URL(string: BuildSettings.applicationHelpUrlString) else {
                return
            }

            let safariViewController = SFSafariViewController(url: helpURL)

            // Show in fullscreen to animate presentation along side menu dismiss
            safariViewController.modalPresentationStyle = .fullScreen
            self.present(safariViewController, animated: true, completion: nil)
        case 2:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        default:
            break
        }

    }
}
