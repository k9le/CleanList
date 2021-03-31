//
//  SceneDelegate.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 13.03.2021.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let vc = MovieRequestAssembly.create()
        let navVC = UINavigationController(rootViewController: vc)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navVC
        window.makeKeyAndVisible()

        self.window = window
    }

}
