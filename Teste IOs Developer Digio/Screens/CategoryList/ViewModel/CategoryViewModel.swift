//
//  CategoryViewModel.swift
//  Teste IOs Developer Digio
//
//  Created by Luiz on 25/01/23.
//

import Foundation
typealias Reload = () -> Void
typealias Alert = (String) -> Void
class CategoryViewModel {
    private var categoryServiceProtocol: CategoryServiceProtocol
    var showMessage: Alert?
    var reloadDataTable: Reload?
    var openCategoryDetail: ((_ title: String, _ urlImage:String, _ description: String) -> Void)?
    var reloadSpotLightCollection: Reload?
    var reloadProductCellCollection: Reload?
    var fillDataCash: ((CashViewModel) -> Void)?
    var spotLightCellsViewModel = [SpotLightCellViewModel]() {
        didSet {
            reloadSpotLightCollection?()
        }
    }
    var productCellsViewModel = [ProductCellViewModel]()
    var cashViewModel: CashViewModel? {
        didSet {
            if let cashViewModel = cashViewModel {
                fillDataCash?(cashViewModel)
            }
        }
    }
    var category: Category? {
        didSet {
            spotLightCellsViewModel = category?.spotlight.map {
                return createSpotLightCellViewModel(spotLight: $0)
            } ?? []
            productCellsViewModel  = category?.products.map {
                return createProductCellViewModel(product: $0)
            } ?? []
            if let cash = category?.cash {
                cashViewModel = createCashViewModel(cash: cash)
            }
            reloadDataTable?()
        }
    }
    init(categoryServiceProtocol: CategoryServiceProtocol) {
        self.categoryServiceProtocol = categoryServiceProtocol
    }
    func getCategory() {
        self.categoryServiceProtocol.fetch { [weak self] result in
            switch result {
            case .success(let category):
                self?.category = category
            case .failure(let error):
                self?.showMessage?(error.localizedDescription)
            }
        }
    }
    func createSpotLightCellViewModel(spotLight: Spotlight) -> SpotLightCellViewModel {
        return SpotLightCellViewModel(name: spotLight.name,
                                      bannerURL: spotLight.bannerURL,
                                      description: spotLight.description)
    }
    func createProductCellViewModel(product: Product) -> ProductCellViewModel {
        return ProductCellViewModel(imageURL: product.imageURL,
                                    name: product.name,
                                    description: product.description)
    }
    func createCashViewModel(cash: Cash) -> CashViewModel {
        return CashViewModel(title: cash.title, bannerURL: cash.bannerURL, description: cash.description)
    }
    func getSpotLightCellViewModel(at indexPath: IndexPath) -> SpotLightCellViewModel {
        return spotLightCellsViewModel[indexPath.row]
    }
    func getProductCellViewModel(at indexPath: IndexPath) -> ProductCellViewModel {
        return productCellsViewModel[indexPath.row]
    }
}
