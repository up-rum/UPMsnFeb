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
import MatrixSDK

@objc protocol ShareContactDelegate {
    @objc func shareUPContacts(sharedContacts: NSMutableAttributedString)
}

@objcMembers
class UPContactSharingViewController: UIViewController {

    @IBOutlet weak var contactTable: UITableView!
    var _mxSession: MXSession?
    var contactArray: [AvatarInput] = []
    weak var delegate: ShareContactDelegate?
    var contactsAttribString: NSMutableAttributedString?
    weak var roomDataSource: MXKRoomDataSource?
    var selectionArray: [Int] = []
//    var userModel

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        contactTable.register(UINib(nibName: "UPContactsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        contactTable.tableFooterView = UIView()
        contactTable.dataSource = self
        contactTable.delegate = self

        _mxSession = AppDelegate.theDelegate().mxSessions.first as? MXSession

        guard let myrooms = _mxSession?.directRooms else {
            self.showAlertController(message: "You have no contact to share")
            return

        }

        contactArray = []
        for key in myrooms.keys {

            let av: AvatarInput = _mxSession?.avatarInput(for: key) ?? AvatarInput(mxContentUri: "", matrixItemId: "", displayName: "")
            if (av.displayName ?? "").count > 0 {
                let roomMember = (self.roomDataSource?.roomState.members.member(withUserId: av.matrixItemId)) ?? nil
                if roomMember == nil {
                    contactArray.append(av)
                }

            } else {
                var display_name = av.matrixItemId.replacingOccurrences(of: ServerURLs().upHomeServerUrl, with: "")
                display_name = display_name.replacingOccurrences(of: ":", with: "")
                display_name = display_name.replacingOccurrences(of: "@", with: "")
                contactArray.append(AvatarInput(mxContentUri: "", matrixItemId: av.matrixItemId, displayName: display_name))
            }

            MXLog.warning(av)
        }
        MXLog.warning(contactArray)
    }

    @IBAction private func dismissShareContactVC() {
        self.dismiss(animated: true)
    }
    @IBAction private func shareContacts() {
//        var values = [AvatarInput]()
        contactsAttribString = NSMutableAttributedString(string: "")
        guard let selected_indexPaths = contactTable.indexPathsForSelectedRows else {
            self.showAlertController(message: "Please select atleast one contact")
            return
        }
//        contactsAttribString = ""
        for indexPath in selected_indexPaths {
            let cell = contactTable.cellForRow(at: indexPath)
//            values.append(contactArray[indexPath.row])
            MXLog.warning(indexPath.row)
            self.makeMentionAttributedString(contact: contactArray[indexPath.row])
        }
        MXLog.warning("contactsAttribString \(contactsAttribString)")
        guard let contactsString = contactsAttribString else {
            return
        }
        self.delegate?.shareUPContacts(sharedContacts: contactsString)
        self.dismiss(animated: true)

    }

}

extension UPContactSharingViewController {
    func showAlertController(message: String?){
        let alert = UIAlertController(title: "", message: message ?? "Unable to connect please try later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
        }
        ))
        self.present(alert, animated: true, completion: nil)
    }

    func makeMentionAttributedString(contact: AvatarInput) {


//        let newAttributedString = NSMutableAttributedString(attributedString: contact)

//        guard let roomDataSource = roomDataSource else { return }
//        let roomMember:MXRoomMember = roomDataSource.roomState.members.member(withUserId: contact.matrixItemId ?? "")
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
        let myAttrString = NSAttributedString(string: "", attributes: myAttribute)

        let newAttributedString = NSMutableAttributedString(attributedString: myAttrString)

        if (contact.displayName?.count ?? 0) > 0 {
            if #available(iOS 15.0, *) {
                newAttributedString.append(PillsFormatter.mentionPill(withUserInfo: contact, isHighlighted: false,
                                                                      font: UIFont.systemFont(ofSize: 15)))
            } else {
                newAttributedString.appendString((contact.displayName?.count ?? 0) > 0 ? contact.displayName : contact.matrixItemId.replacingOccurrences(of: ServerURLs().upHomeServerUrl, with: ""))
            }
            newAttributedString.appendString(" ")
        } else if contact.matrixItemId == self._mxSession?.myUser.userId {
            newAttributedString.appendString("/me ")
        } else {
            if #available(iOS 15.0, *) {
                newAttributedString.append(PillsFormatter.mentionPill(withUserInfo: contact, isHighlighted: false,
                                                                      font: UIFont.systemFont(ofSize: 15)))
            } else {
                newAttributedString.appendString((contact.displayName?.count ?? 0) > 0 ? (contact.displayName ?? "") : contact.matrixItemId.replacingOccurrences(of: ServerURLs().upHomeServerUrl, with: ""))
            }

        }
        contactsAttribString?.append(newAttributedString)

    }
}

extension UPContactSharingViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return contactArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "cell") as? UPContactsTableViewCell)!
            let model = contactArray[indexPath.row]

        cell.selectionStyle = .none
        cell.contactName.text = contactArray[indexPath.row].displayName
        let avatarGenerator = AvatarGenerator.generateAvatar(forMatrixItem: model.matrixItemId, withDisplayName: model.displayName)
        cell.avatarIcon.setImageURI(model.mxContentUri, withType: nil, andImageOrientation: .up, previewImage: avatarGenerator, mediaManager: _mxSession?.mediaManager)

            return cell
    }
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//
//    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 20, width: tableView.frame.size.width, height: 70))
        let footer = UILabel(frame: CGRect(x: 16, y: 0, width: footerView.frame.width - 32, height: 60))
        footer.text = "You can share only those contacts who are in your contact list "
        footer.numberOfLines = 2
        footer.textColor = UIColor.white
        footer.font = UIFont.systemFont(ofSize: 14)
        footerView.addSubview(footer)
        return footerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        60
    }
    
}
