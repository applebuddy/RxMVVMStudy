//
//  AppDelegate.swift
//  RxMemo
//
//  Created by MinKyeongTae on 01/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import CoreData
import UIKit

// 5-14) Rx 구현을 하면, Cocoa구현에 비교하면 초기 셋팅이 좀더 복잡할 수 있지만, 앱 요소들 간의 의존성이 비교적 느슨해지고, 이후 추가 기능을 구현 및 변경하는 것이 훨씬 편리해집니다.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 5-14) 앱이 실행되면 아래에서 메모리 저장소 및 Scene코디네이터가 생성됩니다.
        // let storage = MemoryStorage()

        // 21-16:30) storage를 CoreDataStorage로 교체해줍니다. 이렇게 되면 RxCoreData로 메모 데이터가 관리됩니다.
        // Q) 이후 메모를 편집하고, 다시 편집 버튼을 누르면 이전의 메모내용이 나옵니다. 이부분을 직접 해결해 보십시오.
        let storage = CoreDataStorage(modelName: "RxMemo")
        let coordinator = SceneCoordinator(window: window!)

        // 5-12) Scene 열거형에 선언되어있는 list Scene을 선언해보겠습니다.
        // 5-14:50) 위의 storage, coordinator에 대한 의존성은 listViewModel에 두개의 인스턴스로서 주입되면서 활용됩니다.
        // listViewModel은 두개의 인스턴스를 주입하면서 생성됩니다.
        let listViewModel = MemoListViewModel(title: "나의 메모",
                                              sceneCoordinator: coordinator,
                                              storage: storage)

        // 새로운 Scene을 생성하고, 연관값으로 viewModel을 저장합니다.
        let listScene = Scene.list(listViewModel)

        // transition 타입을 .root로 전달합니다.
        // transition 메서드 내에서 실제 전달할 Scene을 생성합니다.
        coordinator.transition(to: listScene, using: .root, animated: false)

        return true
    }

    // MARK: - Core Data Stack

    // MARK: - Core Data Saving Support

    // #13 3:32) 아래의 코드는 삭제 하겠습니다.
//    func saveContext() {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }

//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
}
