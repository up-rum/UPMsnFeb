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

class MyRecentCallViewController: UIViewController, MasterTabBarItemDisplayProtocol {
    private let MSEC_PER_SEC: TimeInterval = 1000

    @IBOutlet var callHistoryTable: UITableView!
    var callevents = [RecentCallData]()
    var _mxSession : MXSession?

    var masterTabBarItemTitle: String {
        return "Call History"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Call History"
        navigationItem.largeTitleDisplayMode = .never
         _mxSession = AppDelegate.theDelegate().mxSessions.first as? MXSession
        callHistoryTable.register(UINib(nibName: "UPPlaceholderTableViewCell", bundle: nil), forCellReuseIdentifier: "placeholdercell")

        callHistoryTable.register(UINib(nibName: "CallHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        callHistoryTable.tableFooterView = UIView()
        callHistoryTable.dataSource = self
        callHistoryTable.delegate = self
//        callHistoryTable.backgroundColor = ThemeService.shared().theme.colors.background
//        self.tabBarController?.tabBar.barTintColor = ThemeService.shared().theme.colors.background

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.getCallHistory()
        }
    }
    func convertTimeStampToDate(age : UInt) {
//        let date = NSDate() // current date
//        let unixtime = TimeIntervalvalSince1970
        let epocTime = TimeInterval(age)

        let myDate = NSDate(timeIntervalSince1970: epocTime)
        MXLog.warning("Converted Time \(myDate)")

        var date = Date(timeIntervalSince1970: (Double(age) / 1000.0))
        MXLog.warning("date - \(date)")
    }
    
    func getCallHistory() {
        guard let mxSession = AppDelegate.theDelegate().mxSessions.first as? MXSession else { return }
        var recentCallData = [String :Any]()
        let rooms = mxSession.rooms

        callevents.removeAll()


        for room in rooms {
            
            guard let enumerator = room.enumeratorForStoredMessagesWithType(in: [kMXEventTypeStringCallInvite]) else {return}
            var event = RecentCallData()
            var callEvent = enumerator.nextEvent
            while( callEvent != nil) {
                var userId :String?
                if (callEvent?.sender == mxSession.myUserId) {
                    userId = mxSession.directUserId(inRoom: callEvent?.roomId)
                }
                else {
                    userId = callEvent?.sender
                }

                if userId != nil {
                    event.user = mxSession.user(withUserId: userId)
                    
                }
                event.event = callEvent
                // Set date time
                var _date = NSDate()
                var date_string = ""
//                var eArr = [MXEvent]()
//                eArr.append(callEvent!)
//                let callInviteEventContent: MXCallInviteEventContent = MXCallInviteEventContent(fromJSON: callEvent?.content)
////                MXCallEventContent(fromJSON: callEvent?.content)
//                if callInviteEventContent.callId != nil {
//                    let call = mxSession.callManager.call(withCallId: callInviteEventContent.callId)
//
//                    MXLog.warning("Display// callid:: \(callInviteEventContent.callId)")
//                    MXLog.warning("Event====>>>\(call)")
////                    MXLog.warning("EventAge====>>>\(event.event?.jsonDictionary())")
//
//                }

//                var duration = callDuration(from: eArr)
//                MXLog.warning("duration ==$$:: \(duration)")
                
                if callEvent?.originServerTs != kMXUndefinedTimestamp {
                    _date = NSDate(timeIntervalSince1970: Double(callEvent?.originServerTs ?? UInt64(1432233446145.0))/1000)
                    date_string = dateStringFromDate(date: _date)
                    event.dateTimeString = date_string
                }
                
                callevents.append(event)
                callEvent = enumerator.nextEvent


//                self.convertTimeStampToDate(age: UInt(event.event?.ageLocalTs ?? 0))
            }

        }
//        [callEvents sortUsingComparator:^NSComparisonResult(MXEvent * _Nonnull event1, MXEvent * _Nonnull event2) {
//            return [@(event1.age) compare:@(event2.age)];
        callevents = callevents.sorted { event1, event2 in
            event1.event?.age ?? 0 < event2.event?.age ?? 0
        }
        callHistoryTable.isHidden = false
        callHistoryTable.reloadData()
    }
    private func callDuration(from events: [MXEvent]) -> TimeInterval {
        guard let startDate = events.first(where: { $0.eventType == .callAnswer })?.originServerTs else {
            //  never started
            return 0
        }
        guard let endDate = events.first(where: { $0.eventType == .callHangup })?.originServerTs
                ?? events.first(where: { $0.eventType == .callReject })?.originServerTs else {
            //  not ended yet, compute the diff from now
            return (NSTimeIntervalSince1970 - TimeInterval(startDate))/MSEC_PER_SEC
        }

        guard startDate < endDate else {
            // started but hung up/rejected on other end around the same time
            return 0
        }

        //  ended, compute the diff between two dates
        return TimeInterval(endDate - startDate)/MSEC_PER_SEC
    }
    func dateStringFromDate(date:NSDate) -> String {
        // Get first date string without time (if a date format is defined, else only time string is returned)
        var dateString = ""
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMM hh:mm a"
        if ((dateFormatter.dateFormat) != nil) {

            dateString = dateFormatter.string(from: date as Date)
        }
        let calendar = Calendar.current
        var today = calendar.startOfDay(for: Date())

        var interval: TimeInterval = -(date.timeIntervalSinceNow)

        if (interval > 60*60*24*364) {
            dateFormatter.dateFormat  = "MMM dd yyyy"
            dateString = dateFormatter.string(from: date as Date)
        } else if (interval > 60*60*24*6) {
            dateFormatter.dateFormat  = "MMM dd"
            dateString = dateFormatter.string(from: date as Date)
        } else if (interval > 60*60*24) {
//            if (time)
//            {
                dateFormatter.dateFormat  = "EEE"
//            }
//            else
//            {
//                dateFormatter.dateFormat  = "EEEE"
//            }

            dateString = dateFormatter.string(from: date as Date)
        }
        else if (interval > 0) {
//            if (time)
//            {
//                [dateFormatter setDateFormat:nil];
//                return [NSString stringWithFormat:@"%@ %@", [VectorL10n yesterday], [super dateStringFromDate:date withTime:YES]];
//            }
            dateFormatter.dateFormat = "hh:mm a"
            dateString = dateFormatter.string(from: date as Date) //VectorL10n.yesterday
//            return [VectorL10n yesterday];
        }
        else if (interval > -60*60*24) {
//            if (time)
//            {
//                [dateFormatter setDateFormat:nil];
//                return [NSString stringWithFormat:@"%@", [super dateStringFromDate:date withTime:YES]];
//            }
            dateFormatter.dateFormat = "MMM dd hh:mm a"
            dateString = dateFormatter.string(from: date as Date)
//                dateString = VectorL10n.today
//            return [VectorL10n today];
        }
        else
        {
            // Date in future
            dateFormatter.dateFormat = "EEE MMM dd yyyy"
            dateString = dateFormatter.string(from: date as Date)
//            [dateFormatter setDateFormat:@"EEE MMM dd yyyy"];
//            return [super dateStringFromDate:date withTime:time];
        }

        return dateString
    }

}
extension MyRecentCallViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return callevents.count == 0 ? 1 : callevents.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if callevents.count == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "placeholdercell") as? UPPlaceholderTableViewCell)!
            return cell
        } else {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "cell") as? CallHistoryTableViewCell)!
            let model = callevents[indexPath.row]
        cell.selectionStyle = .none
//            if model.fileType == "pdf" {
//                cell.typeIcon.image = UIImage(named: "pdf_icon")
//            }
//            else{
//                cell.typeIcon.image = UIImage(named: "imgicn")
//            }
//            let nameSTR = model.name?.removingPercentEncoding
        cell.callername.text = model.user?.displayName ?? ""
        cell.callDate.text = model.dateTimeString ?? ""
        cell.callStatus.text = VectorL10n.callEnded //model.event?.type ?? ""
        cell.avatarIcon.setImageURI(model.user?.avatarUrl, withType: nil, andImageOrientation: .up, previewImage: AvatarGenerator.generateAvatar(forMatrixItem: model.user?.userId, withDisplayName: model.user?.displayName), mediaManager: _mxSession?.mediaManager)
//            cell.sizeLab.text = model.size ?? ""
//            cell.createdOnLab.text = "Created On \(model.createdOn ?? "")"
//            cell.optionsBtn.addTarget(self, action: #selector(showAlert(sender:)), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let room: MXRoom = (_mxSession?.room(withRoomId: callevents[indexPath.row].event?.roomId ?? "0")) else { return }
        if room.summary.membership == MXMembership.invite {
            Analytics.shared.joinedRoomTrigger = AnalyticsJoinedRoomTrigger.invite
        }
        // Avoid multiple openings of rooms

        self.callHistoryTable.isUserInteractionEnabled = false
//        self.userInteractionEnabled = false

        // Do not stack views when showing room
        let presentationParameters: ScreenPresentationParameters = ScreenPresentationParameters(restoreInitialDisplay: false, stackAboveVisibleViews: false)

        let parameters: RoomNavigationParameters = RoomNavigationParameters(roomId: room.roomId, eventId: nil, mxSession: _mxSession!, threadParameters: nil, presentationParameters: presentationParameters)
        AppDelegate.theDelegate().showRoom(with: parameters) {
            self.callHistoryTable.isUserInteractionEnabled = true
        }
    }
}

struct RecentCallData {
    var user: MXUser?
    var event: MXEvent?
    var dateTimeString: String?
    var callType: String?
    var callStatus: String?
}
