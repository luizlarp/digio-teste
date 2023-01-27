//
//  CategoryService.swift
//  Teste IOs Developer Digio
//
//  Created by Luiz on 25/01/23.
//

import Foundation

protocol CategoryServiceProtocol {
    func fetch(callBack: @escaping(Result<Category, HandleError>) -> Void)
}

class CategoryMockService: CategoryServiceProtocol {
    func fetch(callBack: @escaping (Result<Category, HandleError>) -> Void) {
        guard let parseCategory = try? Category.parse(jsonFile: "CategoryList") else {
            callBack(.failure(.erroParseData))
            return
        }
        callBack(.success(parseCategory))
    }
}

class CategoryService: CategoryServiceProtocol {
    func fetch(callBack: @escaping (Result<Category, HandleError>) -> Void) {
        let urlRequestProducts =
        URL(string: "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products")
        guard let urlRequestProducts = urlRequestProducts else {
            return
        }
        let config = URLSessionConfiguration.default
        URLSession(configuration: config).dataTask(with: URLRequest(url: urlRequestProducts)) { response in
            do {
                switch response {
                case .success(let response):
                    let category: Category = try JSONDecoder().decode(Category.self, from: response.1)
                    return callBack(.success(category))
                case .failure(let error):
                    return callBack(.failure(error as? HandleError ?? HandleError.genericError))
                }
            } catch {
                return callBack(.failure(.erroParseData))
            }
        }.resume()
    }
}
