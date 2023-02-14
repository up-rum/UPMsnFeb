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

import Foundation
import UIKit
import MatrixSDK

/// Provides utilities funcs to handle Pills inside attributed strings.
@available (iOS 15.0, *)
@objcMembers
class PillsFormatter: NSObject {
    // MARK: - Internal Properties
    /// UTType identifier for pills. Should be declared as Document type & Exported type identifier inside Info.plist
    static let pillUTType: String = "com.unplugged.messenger.pills"

    // MARK: - Internal Enums
    /// Defines a replacement mode for converting Pills to plain text.
    @objc enum PillsReplacementTextMode: Int {
        case displayname
        case identifier
        case markdown
    }

    // MARK: - Internal Methods
    /// Insert text attachments for pills inside given message attributed string.
    ///
    /// - Parameters:
    ///   - attributedString: message string to update
    ///   - session: current session
    ///   - eventFormatter: the event formatter
    ///   - event: the event
    ///   - roomState: room state for message
    ///   - latestRoomState: latest room state of the room containing this message
    ///   - isEditMode: whether this string will be used in the composer
    /// - Returns: new attributed string with pills
    static func insertPills(in attributedString: NSAttributedString,
                            withSession session: MXSession,
                            eventFormatter: MXKEventFormatter,
                            event: MXEvent,
                            roomState: MXRoomState,
                            andLatestRoomState latestRoomState: MXRoomState?,
                            isEditMode: Bool = false) -> NSAttributedString {
        let newAttr = NSMutableAttributedString(attributedString: attributedString)
        newAttr.vc_enumerateAttribute(.link) { (url: URL, range: NSRange, _) in
            if let userId = userIdFromPermalink(url.absoluteString),
               let roomMember = roomMember(withUserId: userId,
                                           roomState: roomState,
                                           andLatestRoomState: latestRoomState) {
                let isHighlighted = roomMember.userId == session.myUserId && event.sender != session.myUserId
                let attachmentString = mentionPill(withRoomMember: roomMember,
                                                   andUrl: isEditMode ? nil : url,
                                                   isHighlighted: isHighlighted,
                                                   font: eventFormatter.defaultTextFont)
                newAttr.replaceCharacters(in: range, with: attachmentString)
            }
            else {
                MXLog.warning("userid-->> \(url.absoluteString)")
                if let userId = userIdFromPermalink(url.absoluteString) {
                    let _mxSession = AppDelegate.theDelegate().mxSessions.first as? MXSession

                    let user_detail = _mxSession?.avatarInput(for: userId) ?? AvatarInput(mxContentUri: "", matrixItemId: userId, displayName: "")
                    var display_name = user_detail.displayName ?? ""
                    if display_name.count == 0 {
                        display_name = user_detail.matrixItemId.replacingOccurrences(of: ServerURLs().upHomeServerUrl, with: "")
                        display_name = display_name.replacingOccurrences(of: ":", with: "")
                        display_name = display_name.replacingOccurrences(of: "@", with: "")
                    }

                    let attachmentString = mentionPill(withUserInfo: AvatarInput(mxContentUri: nil, matrixItemId: userId, displayName: display_name),andUrl: isEditMode ? nil : url, isHighlighted: false, font: eventFormatter.defaultTextFont)
                    newAttr.replaceCharacters(in: range, with: attachmentString)
                }
            }
        }

        return newAttr
    }

    /// Creates a string with all pills of given attributed string replaced by display names.
    ///
    /// - Parameters:
    ///   - attributedString: attributed string with pills
    ///   - mode: replacement mode for pills (default: displayname)
    /// - Returns: string with display names
    static func stringByReplacingPills(in attributedString: NSAttributedString,
                                       mode: PillsReplacementTextMode = .displayname) -> String {
        let newAttr = NSMutableAttributedString(attributedString: attributedString)
        newAttr.vc_enumerateAttribute(.attachment) { (attachment: PillTextAttachment, range: NSRange, _) in
            if let displayText = attachment.data?.displayText,
               let userId = attachment.data?.matrixItemId,
               let permalink = MXTools.permalinkToUser(withUserId: userId) {
                let pillString: String
                switch mode {
                case .displayname:
                    pillString = displayText
                case .identifier:
                    pillString = userId
                case .markdown:
                    pillString = "[\(displayText)](\(permalink))"
                }
                newAttr.replaceCharacters(in: range, with: pillString)
            }
        }

        return newAttr.string
    }

    /// Creates an attributed string containing a pill for given room member.
    ///
    /// - Parameters:
    ///   - roomMember: the room member
    ///   - url: URL to room member profile. Should be provided to make pill act as a link.
    ///   - isHighlighted: true to indicate that the pill should be highlighted
    ///   - font: the text font
    /// - Returns: attributed string with a pill attachment and an optional link
    static func mentionPill(withRoomMember roomMember: MXRoomMember,
                            andUrl url: URL? = nil,
                            isHighlighted: Bool,
                            font: UIFont) -> NSAttributedString {
        guard let attachment = PillTextAttachment(withRoomMember: roomMember, isHighlighted: isHighlighted, font: font) else {
            return NSAttributedString(string: roomMember.displayname)
        }
        let string = NSMutableAttributedString(attachment: attachment)
        string.addAttribute(.font, value: font, range: .init(location: 0, length: string.length))
        if let url = url {
            string.addAttribute(.link, value: url, range: .init(location: 0, length: string.length))
        }
        return string
    }

    //Rum
    static func mentionPill(withUserInfo userData: AvatarInput,
                            andUrl url: URL? = nil,
                            isHighlighted: Bool,
                            font: UIFont) -> NSAttributedString {
        guard let attachment = PillTextAttachment(withUserInfo: userData, isHighlighted: isHighlighted, font: font) else {
            return NSAttributedString(string: userData.displayName ?? "")
        }
        let string = NSMutableAttributedString(attachment: attachment)
        string.addAttribute(.font, value: font, range: .init(location: 0, length: string.length))
        if let url = url {
            string.addAttribute(.link, value: url, range: .init(location: 0, length: string.length))
        }
        return string
    }
    

    /// Update alpha of all `PillTextAttachment` contained in given attributed string.
    ///
    /// - Parameters:
    ///   - alpha: Alpha value to apply
    ///   - attributedString: Attributed string containing the pills
    static func setPillAlpha(_ alpha: CGFloat, inAttributedString attributedString: NSAttributedString) {
        attributedString.vc_enumerateAttribute(.attachment) { (pill: PillTextAttachment, range: NSRange, _) in
            pill.data?.alpha = alpha
        }
    }

    /// Refresh pills inside given attributed string.
    /// 
    /// - Parameters:
    ///   - attributedString: attributed string to update
    ///   - roomState: room state for refresh, should be the latest available
    static func refreshPills(in attributedString: NSAttributedString, with roomState: MXRoomState) {
        attributedString.vc_enumerateAttribute(.attachment) { (pill: PillTextAttachment, range: NSRange, _) in
            guard let userId = pill.data?.matrixItemId,
                  let roomMember = roomState.members.member(withUserId: userId) else {
                return
            }

            pill.data?.displayName = roomMember.displayname
            pill.data?.avatarUrl = roomMember.avatarUrl
        }
    }
}

// MARK: - Private Methods
@available (iOS 15.0, *)
private extension PillsFormatter {
    /// Extract user id from given permalink
    /// - Parameter permalink: the permalink
    /// - Returns: userId, if any
    static func userIdFromPermalink(_ permalink: String) -> String? {
        let baseUrl: String
        if let clientBaseUrl = BuildSettings.clientPermalinkBaseUrl {
            baseUrl = String(format: "%@/#/", clientBaseUrl)
        } else {
            baseUrl = String(format: "%@/#/", kMXMatrixDotToUrl)
        }
        return permalink.starts(with: baseUrl) ? String(permalink.dropFirst(baseUrl.count)) : nil
    }

    /// Retrieve the latest available `MXRoomMember` from given data.
    ///
    /// - Parameters:
    ///   - userId: the id of the user
    ///   - roomState: room state for message
    ///   - latestRoomState: latest room state of the room containing this message
    /// - Returns: the room member, if available
    static func roomMember(withUserId userId: String,
                           roomState: MXRoomState,
                           andLatestRoomState latestRoomState: MXRoomState?) -> MXRoomMember? {
        return latestRoomState?.members.member(withUserId: userId) ?? roomState.members.member(withUserId: userId)
    }
}
