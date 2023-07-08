//
//  TabBarController.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 06.07.2023.
//

import UIKit

final class TabBarControllerFactory {

    static func getTabBarController() -> UITabBarController {
        let profileNavController = UINavigationController(rootViewController: ProfileViewController())
        profileNavController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.crop.circle.fill"),
            tag: 0
        )

        let catalogueNavController = UINavigationController(rootViewController: CatalogViewController(viewModel: CatalogViewModel(alertModel: nil)))
        catalogueNavController.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage(systemName: "rectangle.stack.fill"),
            tag: 0
        )

        let cartNavController = UINavigationController(rootViewController: CartViewController())
        cartNavController.tabBarItem = UITabBarItem(
            title: "Корзина",
            image: UIImage(systemName: "trash"),
            tag: 0
        )

        let statisticsNavController = UINavigationController(rootViewController: RatingViewController())
        statisticsNavController.navigationBar.isHidden = true
        statisticsNavController.view.backgroundColor = UIColor.white
        statisticsNavController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "flag.2.crossed.fill"),
            tag: 0
        )

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            profileNavController, catalogueNavController,
            cartNavController, statisticsNavController
        ]
        tabBarController.selectedIndex = 1

        tabBarController.tabBar.backgroundColor = UIColor.white
        tabBarController.tabBar.tintColor = UIColor.blue
        tabBarController.tabBar.isTranslucent = false

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white
        tabBarAppearance.shadowImage = nil
        tabBarAppearance.shadowColor = nil

        tabBarController.tabBar.standardAppearance = tabBarAppearance
        return tabBarController
    }
}
