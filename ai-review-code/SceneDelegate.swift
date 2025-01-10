//
//  SceneDelegate.swift
//  ai-review-code
//
//  Created by Dinh Van Vu on 10/01/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
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

