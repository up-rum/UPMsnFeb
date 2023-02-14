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

class TimeLimitedSettingController: UIViewController {
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var enableBT, saveBT: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    var timeUnit = ["Minutes", "Hours"]
    var timeValue: Int = 1
    var timeIn: String = "Minutes"
    //    var hour: Int = 0
//        var minutes: Int = 0
//        var seconds: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBT.isHidden = false
        let timeLimit: Int = (UserDefaults.standard.value(forKey: "timelimit") as? Int) ?? 0
        MXLog.warning("timeLimit==>> \(timeLimit)")
        if timeLimit > 0 {
            enableBT.isSelected = true
            if timeLimit >= 60000 && timeLimit < 3600000 {
                let value = timeLimit/60000
                timeLab.text = "\(value ) Minutes"
            }
            else if timeLimit >= 3600000 && timeLimit < 86400000 {
                let value = timeLimit/(60 * 60000)
                timeLab.text = "\(value ) Hours"
            }
            else if timeLimit >= 86400000 {
                let value = timeLimit/(60 * 60000 * 24)
                timeLab.text = "\(value ?? 0) Days"
            }
            else {
                var value = timeLimit/(1000)
                timeLab.text = "\(value ?? 0) Seconds"
            }

        }
        else {
            enableBT.isSelected = false
            timeLab.text = ""
        }
//        self.openTimePicker()
        picker.isHidden = false
    }
    @IBAction func enableTimeLimited() {
        if enableBT.isSelected {
//            saveBT.isHidden = true
//            picker.isHidden = true
            }
        else {
//            saveBT.isHidden = false
//            picker.isHidden = false
        }
        enableBT.isSelected = !enableBT.isSelected
    }

    @IBAction func saveTime() {
        var value = 0
        switch timeIn {
        case "Days":
            value = Int(timeValue * 60 * 60 * 24 * 1000)
        case "Minutes":
            value = Int(timeValue * 60 * 1000)
        case "Hours":
            value = Int(timeValue * 60 * 60 * 1000)
        default: break

        }
        if enableBT.isSelected {
            UserDefaults.standard.set(value, forKey: "timelimit")
            }
        else {
            UserDefaults.standard.set(0, forKey: "timelimit")
        }

        self.dismiss(animated: true)
    }
}
extension TimeLimitedSettingController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 50
        case 1:
            return 2

        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        MXLog.warning("rowww \(row) ==timeunitt \(timeUnit)")
        switch component {
        case 0:
            return "\(row + 1)"
        case 1:
            return timeUnit[row]
//        case 2:
//            return "\(row)"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            timeValue = row + 1
        case 1:
            timeIn = timeUnit[row]

        default:
            break
        }
        timeLab.text = "\(timeValue ?? 0) " + timeIn
    }
}
