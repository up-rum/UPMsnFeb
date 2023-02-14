//
// Copyright 2020 Vector Creations Ltd
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
import PushKit
import MatrixSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties

    // MARK: Private

    private var appCoordinator: AppCoordinatorType!
    private var rootRouter: RootRouterType!

    private var legacyAppDelegate: LegacyAppDelegate {
        return AppDelegate.theDelegate()
    }
    
    // MARK: Public
    
    /// Call the Riot legacy AppDelegate
    @objc class func theDelegate() -> LegacyAppDelegate {
        guard let legacyAppDelegate = LegacyAppDelegate.the() else {
            fatalError("[AppDelegate] theDelegate property should not be nil")
        }
        return legacyAppDelegate
    }
    
    // UIApplicationDelegate properties
    
    /// Main application window
    var window: UIWindow?
    
    // MARK: - UIApplicationDelegate
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.month], from: date1, to: date2)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
    // MARK: Life cycle
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let date = UserDefaults.standard.object(forKey: "syncDate") as? Date
        MXLog.warning("abc===>> \(date)")


       var isDifferentDay = false
        let dateToday = Calendar.current.component(.day, from: Date())


        if date != nil {
            let date2 = Calendar.current.component(.day, from: date ?? Date())
            if dateToday == date2 {
               isDifferentDay = false
           }
            else {
                isDifferentDay = true
            }
        }
        else {
            isDifferentDay = true
        }

//        nextDate.compare(is)
        MXLog.warning(isSameDay)
        if isDifferentDay {
            APIServices.shared.upLastSyncApi { result in
                MXLog.warning("Success")
            } failure: { failureMsg in
                MXLog.warning("failed")
            }

        }
        return self.legacyAppDelegate.application(application, willFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup window
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        // Create AppCoordinator
        self.rootRouter = RootRouter(window: window)
        
        let appCoordinator = AppCoordinator(router: self.rootRouter, window: window)
        appCoordinator.start()
        self.legacyAppDelegate.delegate = appCoordinator
        
        self.appCoordinator = appCoordinator
        
        // Call legacy AppDelegate
        self.legacyAppDelegate.window = window
        self.legacyAppDelegate.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.legacyAppDelegate.applicationDidBecomeActive(application)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {        
        self.legacyAppDelegate.applicationWillResignActive(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.legacyAppDelegate.applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.legacyAppDelegate.applicationWillEnterForeground(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.legacyAppDelegate.applicationWillTerminate(application)
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        self.legacyAppDelegate.applicationDidReceiveMemoryWarning(application)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return self.appCoordinator.open(url: url, options: options)
    }
    
    // MARK: User Activity Continuation
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return self.legacyAppDelegate.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
    
    // MARK: Push Notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.legacyAppDelegate.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        self.legacyAppDelegate.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.legacyAppDelegate.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
}
