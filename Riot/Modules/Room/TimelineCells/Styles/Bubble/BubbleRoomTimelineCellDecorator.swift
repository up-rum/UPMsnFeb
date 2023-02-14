// 
// Copyright 2021 New Vector Ltd
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

class BubbleRoomTimelineCellDecorator: PlainRoomTimelineCellDecorator {
        
    override func addTimestampLabelIfNeeded(toCell cell: MXKRoomBubbleTableViewCell, cellData: RoomBubbleCellData) {
        
        guard self.canShowTimestamp(forCellData: cellData) else {
            return
        }
        
        self.addTimestampLabel(toCell: cell, cellData: cellData)
    }
    override func addTimeLimitLabelIfNeeded(toCell cell: MXKRoomBubbleTableViewCell, cellData: RoomBubbleCellData) {

        guard self.canShowTimestamp(forCellData: cellData) else {
            return
        }

//        self.addTimeLimitLabel(toCell: cell, cellData: cellData)
    }
    
        
    override func addTimestampLabel(toCell cell: MXKRoomBubbleTableViewCell, cellData: RoomBubbleCellData) {
        
        guard let timestampLabel = self.createTimestampLabel(for: cellData) else {
            super.addTimestampLabel(toCell: cell, cellData: cellData)
            return
        }

        guard let timeLimitLabel = self.createTimeLimitLabel(for: cellData) else {
            super.addTimeLimitLabel(toCell: cell, cellData: cellData)
            return
        }

        
        if let timestampDisplayable = cell as? TimestampDisplayable {
            
            timestampDisplayable.addTimestampView(timestampLabel)
            
        } else if cellData.isAttachmentWithThumbnail {
                                                 
            if cellData.attachment?.type == .sticker,
               let attachmentView = cell.attachmentView {
                
                // Prevent overlap with send status icon
                let bottomMargin: CGFloat = BubbleRoomCellLayoutConstants.stickerTimestampViewMargins.bottom
                let rightMargin: CGFloat = BubbleRoomCellLayoutConstants.stickerTimestampViewMargins.right


                self.addTimestampLabel(timestampLabel,
                                       to: cell,
                                       on: cell.contentView,
                                       constrainingView: attachmentView,
                                       rightMargin: rightMargin,
                                       bottomMargin: bottomMargin)
                self.addTimeLimitLabel(timeLimitLabel,
                                       cellData: cellData,
                                       to: cell,
                                       on: cell.contentView,
                                       constrainingView: attachmentView,
                                       rightMargin: rightMargin,
                                       bottomMargin: bottomMargin-20)
                
            } else if let attachmentView = cell.attachmentView {
                // For media with thumbnail cells, add timestamp inside thumbnail
                
                timestampLabel.textColor = self.theme.baseIconPrimaryColor
                timeLimitLabel.textColor = .white//self.theme.baseIconPrimaryColor

                self.addTimestampLabel(timestampLabel,
                                       to: cell,
                                       on: cell.contentView,
                                       constrainingView: attachmentView)
                self.addTimeLimitLabel(timeLimitLabel,
                                       cellData: cellData,
                                       to: cell,
                                       on: cell.contentView,
                                       constrainingView: attachmentView)
                
            } else {
                super.addTimestampLabel(toCell: cell, cellData: cellData)
            }
        } else if let voiceMessageCell = cell as? VoiceMessagePlainCell, let playbackView = voiceMessageCell.playbackController?.playbackView {
            
            // Add timestamp on cell inherting from VoiceMessageBubbleCell
            timestampLabel.textColor = self.theme.baseIconPrimaryColor
            timeLimitLabel.textColor = .white//self.theme.baseIconPrimaryColor
            self.addTimestampLabel(timestampLabel,
                                   to: cell,
                                   on: cell.contentView,
                                   constrainingView: playbackView)
            self.addTimeLimitLabel(timeLimitLabel,
                                   cellData: cellData,
                                   to: cell,
                                   on: cell.contentView,
                                   constrainingView: playbackView)
            
            
        } else if let fileWithoutThumbnailCell = cell as? FileWithoutThumbnailBaseBubbleCell, let fileAttachementView = fileWithoutThumbnailCell.fileAttachementView {
            
            // Add timestamp on cell inherting from VoiceMessageBubbleCell
            
            self.addTimestampLabel(timestampLabel,
                                   to: cell,
                                   on: fileAttachementView,
                                   constrainingView: fileAttachementView)
            self.addTimestampLabel(timeLimitLabel,
                                   to: cell,
                                   on: cell.contentView,
                                   constrainingView: fileAttachementView)
            
        } else {
            super.addTimestampLabel(toCell: cell, cellData: cellData)
        }
    }

    override func addTimeLimitLabel(toCell cell: MXKRoomBubbleTableViewCell, cellData: RoomBubbleCellData) {


        guard let timelimitLabel = self.createTimeLimitLabel(for: cellData) else {
            super.addTimeLimitLabel(toCell: cell, cellData: cellData)
            return
        }

        if let timestampDisplayable = cell as? TimestampDisplayable {

            timestampDisplayable.addTimestampView(timelimitLabel)

        } else if cellData.isAttachmentWithThumbnail {

            if cellData.attachment?.type == .sticker,
               let attachmentView = cell.attachmentView {

                // Prevent overlap with send status icon
                let bottomMargin: CGFloat = BubbleRoomCellLayoutConstants.stickerTimestampViewMargins.bottom
                let rightMargin: CGFloat = BubbleRoomCellLayoutConstants.stickerTimestampViewMargins.left

                self.addTimeLimitLabel(timelimitLabel, cellData: cellData,
                                       to: cell,
                                       on: cell.contentView,
                                       constrainingView: attachmentView,
                                       rightMargin: rightMargin,
                                       bottomMargin: bottomMargin)


            } else if let attachmentView = cell.attachmentView {
                // For media with thumbnail cells, add timestamp inside thumbnail

                timelimitLabel.textColor = .white//self.theme.baseIconPrimaryColor
                self.addTimeLimitLabel(timelimitLabel, cellData: cellData,
                                       to: cell,
                                       on: cell.contentView,
                                       constrainingView: attachmentView)


            } else {
                super.addTimeLimitLabel(toCell: cell, cellData: cellData)
            }
        } else if let voiceMessageCell = cell as? VoiceMessagePlainCell, let playbackView = voiceMessageCell.playbackController?.playbackView {

            // Add timestamp on cell inherting from VoiceMessageBubbleCell
            self.addTimeLimitLabel(timelimitLabel, cellData: cellData,
                                   to: cell,
                                   on: cell.contentView,
                                   constrainingView: playbackView)


        } else if let fileWithoutThumbnailCell = cell as? FileWithoutThumbnailBaseBubbleCell, let fileAttachementView = fileWithoutThumbnailCell.fileAttachementView {

            // Add timestamp on cell inherting from VoiceMessageBubbleCell

            self.addTimeLimitLabel(timelimitLabel, cellData: cellData,
                                   to: cell,
                                   on: fileAttachementView,
                                   constrainingView: fileAttachementView)

        } else {
            super.addTimeLimitLabel(toCell: cell, cellData: cellData)
        }
    }
    
    override func addReactionView(_ reactionsView: RoomReactionsView,
                                  toCell cell: MXKRoomBubbleTableViewCell, cellData: RoomBubbleCellData, contentViewPositionY: CGFloat, upperDecorationView: UIView?) {
        
        if let reactionsDisplayable = cell as? RoomCellReactionsDisplayable {
            reactionsDisplayable.addReactionsView(reactionsView)
            return
        }
        
        cell.addTemporarySubview(reactionsView)
        
        reactionsView.translatesAutoresizingMaskIntoConstraints = false
        
        let cellContentView = cell.contentView
        
        cellContentView.addSubview(reactionsView)
                
        let topMargin: CGFloat = PlainRoomCellLayoutConstants.reactionsViewTopMargin
        let leftMargin: CGFloat
        let rightMargin: CGFloat
                
        // Incoming message
        if cellData.isIncoming {
            
            var incomingLeftMargin = BubbleRoomCellLayoutConstants.incomingBubbleBackgroundMargins.left
            
            if cellData.containsBubbleComponentWithEncryptionBadge {
                incomingLeftMargin += PlainRoomCellLayoutConstants.encryptedContentLeftMargin
            }
            
            leftMargin = incomingLeftMargin
            
            rightMargin = BubbleRoomCellLayoutConstants.incomingBubbleBackgroundMargins.right
            
        } else {
            // Outgoing message
            
            reactionsView.alignment = .right
                        
            var outgoingLeftMargin = BubbleRoomCellLayoutConstants.outgoingBubbleBackgroundMargins.left
            
            if cellData.containsBubbleComponentWithEncryptionBadge {
                outgoingLeftMargin += PlainRoomCellLayoutConstants.encryptedContentLeftMargin
            }
            
            leftMargin = outgoingLeftMargin
                        
            rightMargin = BubbleRoomCellLayoutConstants.outgoingBubbleBackgroundMargins.right
        }
        
        let leadingConstraint = reactionsView.leadingAnchor.constraint(equalTo: cellContentView.leadingAnchor, constant: leftMargin)
        
        let trailingConstraint = reactionsView.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor, constant: -rightMargin)
        
        let topConstraint: NSLayoutConstraint
        if let upperDecorationView = upperDecorationView {
            topConstraint = reactionsView.topAnchor.constraint(equalTo: upperDecorationView.bottomAnchor, constant: topMargin)
        } else {
            topConstraint = reactionsView.topAnchor.constraint(equalTo: cellContentView.topAnchor, constant: contentViewPositionY + topMargin)
        }
        
        NSLayoutConstraint.activate([
            leadingConstraint,
            trailingConstraint,
            topConstraint
        ])
    }
    
    override func addURLPreviewView(_ urlPreviewView: URLPreviewView,
                                    toCell cell: MXKRoomBubbleTableViewCell,
                                    cellData: RoomBubbleCellData,
                                    contentViewPositionY: CGFloat) {
        
        if let urlPreviewDisplayable = cell as? RoomCellURLPreviewDisplayable {
            urlPreviewView.translatesAutoresizingMaskIntoConstraints = false
            urlPreviewDisplayable.addURLPreviewView(urlPreviewView)
        } else {
            cell.addTemporarySubview(urlPreviewView)
            
            let cellContentView = cell.contentView
            
            urlPreviewView.translatesAutoresizingMaskIntoConstraints = false
            urlPreviewView.availableWidth = cellData.maxTextViewWidth
            cellContentView.addSubview(urlPreviewView)
            
            let leadingOrTrailingConstraint: NSLayoutConstraint
            
            
            // Incoming message
            if cellData.isIncoming {

                var leftMargin = PlainRoomCellLayoutConstants.reactionsViewLeftMargin
                if cellData.containsBubbleComponentWithEncryptionBadge {
                    leftMargin += PlainRoomCellLayoutConstants.encryptedContentLeftMargin
                }
                
                leadingOrTrailingConstraint = urlPreviewView.leadingAnchor.constraint(equalTo: cellContentView.leadingAnchor, constant: leftMargin)
            } else {
                // Outgoing message
                
                let rightMargin: CGFloat = BubbleRoomCellLayoutConstants.outgoingBubbleBackgroundMargins.right
                
                leadingOrTrailingConstraint = urlPreviewView.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor, constant: -rightMargin)
            }
            
            let topMargin = contentViewPositionY + PlainRoomCellLayoutConstants.urlPreviewViewTopMargin + PlainRoomCellLayoutConstants.reactionsViewTopMargin
            
            // Set the preview view's origin
            NSLayoutConstraint.activate([
                leadingOrTrailingConstraint,
                urlPreviewView.topAnchor.constraint(equalTo: cellContentView.topAnchor, constant: topMargin)
            ])
        }
    }
    
    override func addThreadSummaryView(_ threadSummaryView: ThreadSummaryView,
                              toCell cell: MXKRoomBubbleTableViewCell,
                              cellData: RoomBubbleCellData,
                              contentViewPositionY: CGFloat,
                              upperDecorationView: UIView?) {

        if let threadSummaryDisplayable = cell as? RoomCellThreadSummaryDisplayable {
            threadSummaryDisplayable.addThreadSummaryView(threadSummaryView)
        } else {
            
            cell.addTemporarySubview(threadSummaryView)
            threadSummaryView.translatesAutoresizingMaskIntoConstraints = false

            let cellContentView = cell.contentView

            cellContentView.addSubview(threadSummaryView)
            
            var rightMargin: CGFloat
            var leftMargin: CGFloat
            
            let leadingConstraint: NSLayoutConstraint
            let trailingConstraint: NSLayoutConstraint
                        
            // Incoming message
            if cellData.isIncoming {

                leftMargin = BubbleRoomCellLayoutConstants.incomingBubbleBackgroundMargins.left
                if cellData.containsBubbleComponentWithEncryptionBadge {
                    leftMargin += PlainRoomCellLayoutConstants.encryptedContentLeftMargin
                }
                
                rightMargin = BubbleRoomCellLayoutConstants.incomingBubbleBackgroundMargins.right
                
                leadingConstraint = threadSummaryView.leadingAnchor.constraint(equalTo: cellContentView.leadingAnchor,
                                                           constant: leftMargin)
                trailingConstraint = threadSummaryView.trailingAnchor.constraint(lessThanOrEqualTo: cellContentView.trailingAnchor,
                                                                                 constant: -rightMargin)
            } else {
                // Outgoing message
                                
                leftMargin = BubbleRoomCellLayoutConstants.outgoingBubbleBackgroundMargins.left
                rightMargin = BubbleRoomCellLayoutConstants.outgoingBubbleBackgroundMargins.right
                
                leadingConstraint = threadSummaryView.leadingAnchor.constraint(greaterThanOrEqualTo: cellContentView.leadingAnchor,
                                                           constant: leftMargin)
                trailingConstraint = threadSummaryView.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor,
                                                                                 constant: -rightMargin)
            }
            
            let topMargin = PlainRoomCellLayoutConstants.threadSummaryViewTopMargin
            
            let height = ThreadSummaryView.contentViewHeight(forThread: threadSummaryView.thread,
                                                             fitting: cellData.maxTextViewWidth)

            // The top constraint may need to include the URL preview view
            let topConstraint: NSLayoutConstraint
            if let upperDecorationView = upperDecorationView {
                topConstraint = threadSummaryView.topAnchor.constraint(equalTo: upperDecorationView.bottomAnchor,
                                                                       constant: topMargin)
            } else {
                topConstraint = threadSummaryView.topAnchor.constraint(equalTo: cellContentView.topAnchor,
                                                                       constant: contentViewPositionY + topMargin)
            }

            NSLayoutConstraint.activate([
                leadingConstraint,
                trailingConstraint,
                threadSummaryView.heightAnchor.constraint(equalToConstant: height),
                topConstraint
            ])
        }
    }
    
    // MARK: - Private
    
    // MARK: Timestamp management
    
    private func createTimestampLabel(cellData: MXKRoomBubbleCellData, bubbleComponent: MXKRoomBubbleComponent, viewTag: Int, textColor: UIColor) -> UILabel {
        
        let timeLabel = UILabel()

        timeLabel.text = cellData.eventFormatter.timeString(from: bubbleComponent.date)
        timeLabel.textAlignment = .right
        timeLabel.textColor = textColor
        timeLabel.font = self.theme.fonts.caption2
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.tag = viewTag
        timeLabel.accessibilityIdentifier = "timestampLabel"
        
        return timeLabel

    }

    private func createTimeLimitLabel(cellData: MXKRoomBubbleCellData, bubbleComponent: MXKRoomBubbleComponent, viewTag: Int, textColor: UIColor) -> UILabel {


        let timelimitedLabel = UILabel()

        timelimitedLabel.text = "hello 11"//cellData.eventFormatter.timeString(from: Date())// bubbleComponent.date)
        timelimitedLabel.textAlignment = .right
        timelimitedLabel.textColor = textColor
        timelimitedLabel.font = self.theme.fonts.caption2
        timelimitedLabel.adjustsFontSizeToFitWidth = true
        timelimitedLabel.tag = viewTag + 100
        timelimitedLabel.accessibilityIdentifier = "timelimitLabel"

        return timelimitedLabel
    }
    private func createTimeLimitLabel(for cellData: RoomBubbleCellData, textColor: UIColor) -> UILabel? {

        let componentIndex = cellData.mostRecentComponentIndex

        guard let bubbleComponents = cellData.bubbleComponents, componentIndex < bubbleComponents.count else {
            return nil
        }

        let component = bubbleComponents[componentIndex]

        return self.createTimestampLabel(cellData: cellData, bubbleComponent: component, viewTag: componentIndex+100, textColor: textColor)
    }
    func createTimeLimitLabel(for cellData: RoomBubbleCellData) -> UILabel? {
        return self.createTimeLimitLabel(for: cellData, textColor: self.theme.textSecondaryColor)
    }
    func createTimestampLabel(for cellData: RoomBubbleCellData) -> UILabel? {
        return self.createTimestampLabel(for: cellData, textColor: self.theme.textSecondaryColor)
    }
    
    private func createTimestampLabel(for cellData: RoomBubbleCellData, textColor: UIColor) -> UILabel? {
        
        let componentIndex = cellData.mostRecentComponentIndex
        
        guard let bubbleComponents = cellData.bubbleComponents, componentIndex < bubbleComponents.count else {
            return nil
        }
        
        let component = bubbleComponents[componentIndex]

        return self.createTimestampLabel(cellData: cellData, bubbleComponent: component, viewTag: componentIndex, textColor: textColor)
    }
    
    private func canShowTimestamp(forCellData cellData: MXKRoomBubbleCellData) -> Bool {
        
        guard cellData.isCollapsableAndCollapsed == false else {
            return false
        }
        
        guard let firstComponent = cellData.getFirstBubbleComponentWithDisplay(), let firstEvent = firstComponent.event else {
            return false
        }
        
        switch cellData.cellDataTag {
        case .location:
            return true
        case .poll:
            return true
        default:
            break
        }
        
        if let attachmentType = cellData.attachment?.type {
            switch attachmentType {
            case .voiceMessage, .audio:
                return true
            default:
                break
            }
        }
        
        if cellData.isAttachmentWithThumbnail {
            return true
        }
        
        switch firstEvent.eventType {
        case .roomMessage:
            if let messageType = firstEvent.messageType {
                switch messageType {
                case .text, .emote, .file:
                    return true
                default:
                    break
                }
            }
        default:
            break
        }
        
        return false
    }
    
    private func addTimestampLabel(_ timestampLabel: UILabel,
                                   to cell: MXKRoomBubbleTableViewCell,
                                   on containerView: UIView,
                                   constrainingView: UIView,
                                   rightMargin: CGFloat = BubbleRoomCellLayoutConstants.bubbleTimestampViewMargins.right,
                                   bottomMargin: CGFloat = BubbleRoomCellLayoutConstants.bubbleTimestampViewMargins.bottom) {
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false

        cell.addTemporarySubview(timestampLabel)
                
        containerView.addSubview(timestampLabel)
        
        let trailingConstraint = timestampLabel.trailingAnchor.constraint(equalTo: constrainingView.trailingAnchor, constant: -rightMargin)

        let bottomConstraint = timestampLabel.bottomAnchor.constraint(equalTo: constrainingView.bottomAnchor, constant: -bottomMargin)

        NSLayoutConstraint.activate([
            trailingConstraint,
            bottomConstraint
        ])
    }

    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    private func addTimeLimitLabel(_ timelimitLabel: UILabel,
                                   cellData: RoomBubbleCellData,
                                   to cell: MXKRoomBubbleTableViewCell,
                                   on containerView: UIView,
                                   constrainingView: UIView,
                                   rightMargin: CGFloat = BubbleRoomCellLayoutConstants.bubbleTimestampViewMargins.right,
                                   bottomMargin: CGFloat = BubbleRoomCellLayoutConstants.bubbleTimestampViewMargins.bottom) {
        timelimitLabel.translatesAutoresizingMaskIntoConstraints = false
//        var imageSize = CGSizeMake(10, 10);

        let event: MXEvent? =  cellData.events.first
        if event?.content["time_limit"] != nil {
            timelimitLabel.isHidden = false
            let currentTS: UInt64 = UInt64(Date().timeIntervalSince1970 * 1000)
            let msgTS: UInt64 = event?.originServerTs ?? 0
            let timeLimit: UInt64 = currentTS - msgTS
//                NSLog(@"time=limit-=> %lu",(unsigned long)timeLimit);
//                NSLog(@"msgTS=limit-=> %lu",(unsigned long)msgTS);
            MXLog.warning("time===>>>> \(timeLimit)")
            if ((event?.content["time_limit"] ?? 0) as? UInt64 ?? 0 > timeLimit) {


            var eventTime: UInt64 = ((event?.content["time_limit"] ?? 0) as? UInt64 ?? 0) -  timeLimit
            if eventTime > 2000 {

                eventTime = eventTime/1000
                let (h,m,s) = secondsToHoursMinutesSeconds(Int(eventTime))
                let attachment = NSTextAttachment(image: (UIImage(named: "timeLimited")!))
                attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)

                var myString = ""
                if h > 0 {
                    myString = "\(h)h "
                }
                if m > 0 {
                    myString = myString + "\(m)m "
                }
                if s > 0 {
                    myString = myString + "\(s)s"
                }
                let myAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white]
                let myAttrString: NSMutableAttributedString
                myAttrString = NSMutableAttributedString(attachment: attachment)
                myAttrString.append(NSAttributedString(string: myString, attributes: myAttribute))

                timelimitLabel.attributedText = myAttrString
//                timelimitLabel.text = "\(eventTime )"
                cell.addTemporarySubview(timelimitLabel)

                containerView.addSubview(timelimitLabel)

                let trailingConstraint = timelimitLabel.leadingAnchor.constraint(equalTo: constrainingView.leadingAnchor, constant: 10)

                let bottomConstraint = timelimitLabel.bottomAnchor.constraint(equalTo: constrainingView.bottomAnchor, constant: -bottomMargin )

                NSLayoutConstraint.activate([
                    trailingConstraint,
                    bottomConstraint
                ])
            } else {
                NotificationCenter.default.post(name: Notification.Name("deleteTimerMessage"), object: nil)
                }
            } else {
//                NotificationCenter.default.post(name: Notification.Name("deleteTimerMessage"), object: nil)
            }
        } else {
            timelimitLabel.isHidden = true
        }
    }
}
