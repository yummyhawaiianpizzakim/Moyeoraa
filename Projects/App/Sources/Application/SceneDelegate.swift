import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        let nv = UINavigationController()
        let coor = AppCoordinator(navigation: nv)
        self.window?.rootViewController = nv
        self.window?.backgroundColor = .systemBackground
        coor.start()
        self.window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

