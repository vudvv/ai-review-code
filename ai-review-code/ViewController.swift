//
//  ViewController.swift
//  ai-review-code
//
//  Created by Dinh Van Vu on 10/01/2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         sum()
         let a = 0
    }

    func sum() {
         let a = 0
        let b = 1
        let c = a + b
        let d = a + b + c
    }
private func prepareObjecMessageSent(_ object: MesMessageSent) -> MesMessageSent {
        if let attachMent = object.message?.attachment {
            let atk = AttachedFile()
            atk.fileId = attachMent.fileId
            atk.name = attachMent.name
            atk.size = attachMent.size
            atk.date = Date(timeIntervalSince1970: (attachMent.created ?? 0) / 1000)
            atk.mimeType = MimeType.convert(rawValue: attachMent.mimeType)
            atk.officeId = attachMent.officeId
            atk.sendToMedicalStaff = attachMent.sendToMedicalStaff ?? false
            self.listAttachments.append(atk)
        }
        
        if (ChatConstants.officeUserIdChatBot == object.message?.officeUserId) {
            object.message?.displayName = "AP2004_AT_CHAT_BOT".localized
        } else {
            let sentUser = self.listMembers.first(where: {
                $0.id == object.message?.officeUserId
            })
            if (sentUser != nil) {
                object.message?.displayName = sentUser?.displayName ?? ""
                object.message?.accountStatus = sentUser?.accountStatus ?? 2
                if (!(sentUser?.isInvalid())!) {
                    object.message?.officeId = sentUser?.officeId ?? ""
                }
            }
        }
        if (object.message?.officeUserId != self.presenter.currentOfficeUserId) {
            object.message?.read = false
        }
        object.message?.checkMedicalStaff(self.socketPresenter.medicalStaff)
        return object
    }
}

