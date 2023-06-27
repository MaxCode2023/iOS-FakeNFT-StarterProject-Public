//
//  SortAlertPresenter.swift
//  FakeNFT
//
//  Created by macOS on 26.06.2023.
//

import UIKit

final class SortAlertPresenter {

    private var viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func presentSortDialog(
        onNameSort: @escaping () -> Void,
        onRatingSort: @escaping () -> Void
    ) {
        let sortAlertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        sortAlertController.addAction(UIAlertAction(title: "По имени", style: .default) { _ in
            onNameSort()
        })
        sortAlertController.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
            onRatingSort()
        })
        sortAlertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))

        viewController.present(sortAlertController, animated: true)
    }

    func presentSortDialog(
        onPriceSort: @escaping () -> Void,
        onRatingSort: @escaping () -> Void,
        onNameSort: @escaping () -> Void
    ) {
        let sortAlertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        sortAlertController.addAction(UIAlertAction(title: "По цене", style: .default) { _ in
            onPriceSort()
        })
        sortAlertController.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
            onRatingSort()
        })
        sortAlertController.addAction(UIAlertAction(title: "По названию", style: .default) { _ in
            onNameSort()
        })
        sortAlertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))

        viewController.present(sortAlertController, animated: true)
    }
}
