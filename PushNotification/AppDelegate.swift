//
//  AppDelegate.swift
//  PushNotification
//
//  Created by Dimic Milos on 4/25/20.
//  Copyright © 2020 Dimic Milos. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Enable Push Notifications capability to receive push notifications
    
    // Enable Backgorund Modes and tick Remote notifications to have
    // silent backgound notifications
    
    // Add new target for Notification Service Extension to modify notification
    // Make new target deployment target lower than the app target
    // Run the new service extension as the target (select the main app when asked)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(
        options: [.badge, .sound, .alert]) { [weak self] granted, _ in
            guard granted else { return }
            
            center.delegate = self
            
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
                self?.registerCustomActions()
            }
        }
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // This  method gets called in case of silent notification
        // Notification payload needs to contain "content-available"
        // Method is called in the foreground and in the background
        
        guard let text = userInfo["text"] as? String,
            let image = userInfo["image"] as? String,
            let url = URL(string: image) else {
                
                completionHandler(.noData)
                return
        }
        
        print(text, url)
        completionHandler(.newData)
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
       
        // Extract the token if notifications are enabled
        let token = deviceToken.reduce("") {
            $0 + String(format: "%02x", $1)
        }
        print(token)
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        // Handle error if notifications are not enabled
        print(error)
    }
}

// MARK: - UNNotificationCategory & UNNotificationAction

extension AppDelegate {
    
    private var categoryID: String {
        return "Category ID"
    }
    
    private enum ActionIdentifier: String {
        
        case accept
        case reject
        
        var title: String {
            
            switch self {
                
            case .accept:
                return "Prihvati"
            case .reject:
                return "Necu"
            }
        }
    }
    
    private func registerCustomActions() {
        
        let acceptAction = UNNotificationAction(
            identifier: ActionIdentifier.accept.rawValue,
            title: ActionIdentifier.accept.title)
        
        let rejectAction = UNNotificationAction(
            identifier: ActionIdentifier.reject.rawValue,
            title: ActionIdentifier.reject.title)
        
        let category = UNNotificationCategory(
            identifier: categoryID,
            actions: [acceptAction, rejectAction],
            intentIdentifiers: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Implement if you want notifications to be presented while app is in foregound
        completionHandler([.alert, .sound, .badge])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Do stuff with user response on the notification
        // First register custom notification actions
        // Use categoryIdentifier to distinguish between different notifications
        
        defer {
            completionHandler()
        }
        
        let categoryIdentifier = response.notification.request.content.categoryIdentifier
        
        if categoryIdentifier == categoryIdentifier,
            let actionIdentifier = ActionIdentifier(rawValue: response.actionIdentifier) {
            
            let userInfo = response.notification.request.content.userInfo
            
            switch actionIdentifier {
            case .accept:
                Notification.Name.accept.post(userInfo: userInfo)
            case .reject:
                Notification.Name.reject.post(userInfo: userInfo)
            }
        }
    }
}
