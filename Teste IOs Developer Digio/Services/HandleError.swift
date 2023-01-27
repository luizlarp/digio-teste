//
//  HttpError.swift
//  Teste IOs Developer Digio
//
//  Created by Luiz on 25/01/23.
//

import Foundation
enum HandleError: Error {
    case transportError(Error)
    case serverSideError(String)
    case noData
    case erroParseData
    case genericError
}

extension HandleError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .transportError(let error):
            return NSLocalizedString(error.localizedDescription, comment: "Transport error")
        case .serverSideError(let message):
            return NSLocalizedString(message, comment: "Connection error")
        case .noData:
            return NSLocalizedString("Data not found", comment: "")
        case .erroParseData:
            return NSLocalizedString("Error to parse data", comment: "")
        case .genericError:
            return NSLocalizedString("Error try again", comment: "")
        }
    }
}
