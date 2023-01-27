//
//  CategoryTest.swift
//  Teste IOs Developer DigioTests
//
//  Created by Luiz on 24/01/23.
//

import XCTest
@testable import Teste_IOs_Developer_Digio

final class CategoryTest: XCTestCase {
    var viewModel : CategoryViewModel!
    var product: Product!
    var spotlight: Spotlight!
    var cash: Cash!
    var category: Teste_IOs_Developer_Digio.Category!
    override func setUpWithError() throws {
        viewModel = CategoryViewModel(categoryServiceProtocol: CategoryMockService())
        product = Product(imageURL: "https://s3-sa-east-1.amazonaws.com/digio-exame/xbox_icon.png", name: "XBOX", description: "Com o e-Gift Card Xbox vocÃª adquire crÃ©ditos para comprar games, mÃºsica, filmes, programas de TV e muito mais!")
        spotlight = Spotlight(name:"Recarga", bannerURL: "https://s3-sa-east-1.amazonaws.com/digio-exame/recharge_banner.png", description: "Agora ficou mais fÃ¡cil colocar crÃ©ditos no seu celular! A digio Store traz a facilidade de fazer recargas... direto pelo seu aplicativo, com toda seguranÃ§a e praticidade que vocÃª procura.")
        cash = Cash(title: "digio Cash", bannerURL: "https://s3-sa-east-1.amazonaws.com/digio-exame/cash_banner.png", description:  "Dinheiro na conta sem complicaÃ§Ã£o. Transfira parte do limite do seu cartÃ£o para sua conta.")
        category = Category(spotlight: [spotlight], products: [product], cash: cash)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        product = nil
        spotlight = nil
        cash = nil
    }

    func testDecoding() throws {
        XCTAssertNoThrow(try Category.parse(jsonFile: "CategoryList"))
    }
    
    func testCreateProductCellViewModel() {
        let productCellViewModel =  viewModel.createProductCellViewModel(product: product)
        XCTAssertEqual(productCellViewModel.description, product.description, "Description is not the same")
        XCTAssertEqual(productCellViewModel.imageURL, product.imageURL, "ImageURL is not the same")
        XCTAssertEqual(productCellViewModel.name, product.name, "Name is not the same")
    }
    
    func testCreateSpotlightCellViewModel() {
        let spotlightCellViewModel =  viewModel.createSpotLightCellViewModel(spotLight: spotlight)
        XCTAssertEqual(spotlightCellViewModel.description, spotlight.description, "Description is not the same")
        XCTAssertEqual(spotlightCellViewModel.bannerURL, spotlight.bannerURL, "BannerURL is not the same")
        XCTAssertEqual(spotlightCellViewModel.name, spotlight.name, "Name is not the same")
    }
    
    func testCreateCashViewModel() {
        let cashViewModel =  viewModel.createCashViewModel(cash: cash)
        XCTAssertEqual(cashViewModel.description, cash.description, "Description is not the same")
        XCTAssertEqual(cashViewModel.bannerURL, cash.bannerURL, "BannerURL is not the same")
        XCTAssertEqual(cashViewModel.title, cash.title, "Title is not the same")
    }
    
    func testGetSpotLightCellViewModelByIndePath()
    {
        viewModel.category = category
        let spotlightCellViewModel = viewModel.getSpotLightCellViewModel(at: IndexPath(item: 0, section: 0))
        XCTAssertEqual(spotlightCellViewModel.description, spotlight.description, "Description is not the same")
        XCTAssertEqual(spotlightCellViewModel.bannerURL, spotlight.bannerURL, "BannerURL is not the same")
        XCTAssertEqual(spotlightCellViewModel.name, spotlight.name, "Name is not the same")
    }
    
    func testGetProductCellViewModelByIndePath()
    {
        viewModel.category = category
        let productCellViewModel = viewModel.getProductCellViewModel(at: IndexPath(item: 0, section: 0))
        XCTAssertEqual(productCellViewModel.description, product.description, "Description is not the same")
        XCTAssertEqual(productCellViewModel.imageURL, product.imageURL, "BannerURL is not the same")
        XCTAssertEqual(productCellViewModel.name, product.name, "Name is not the same")
    }
     
    func testGetCategoriesAnCheckIfDataAreFilled()
    {
        viewModel.getCategory()
                
        XCTAssertNotNil(viewModel.category, "Category is empty")
        XCTAssertGreaterThan(viewModel.spotLightCellsViewModel.count, 0, "SpotLightCellViewModel list is empty")
        XCTAssertGreaterThan(viewModel.productCellsViewModel.count, 0, "ProductCellViewModel list is empty")
        XCTAssertNotNil(viewModel.cashViewModel, "CashViewModel is empty")
    }
    
}
