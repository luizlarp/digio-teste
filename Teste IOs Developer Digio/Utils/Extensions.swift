//
//  Extensions.swift
//  Teste IOs Developer Digio
//
//  Created by Luiz on 24/01/23.
//

import Foundation
import UIKit
extension UIView {
    func anchor(topAnchor: (anchor: NSLayoutYAxisAnchor,paddingTop: CGFloat)?,
                leftAnchor: (anchor: NSLayoutXAxisAnchor,paddingLeft: CGFloat)?,
                rightAnchor: (anchor: NSLayoutXAxisAnchor,paddingRight: CGFloat)?,
                bottomAnchor: (anchor: NSLayoutYAxisAnchor,paddingBottom: CGFloat)?,
                width: CGFloat = 0, height: CGFloat = 0, enableInsets: Bool = false) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
        }
        translatesAutoresizingMaskIntoConstraints =  false
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor.anchor,
                                      constant: topAnchor.paddingTop + topInset).isActive = true
        }
        if let leftAnchor = leftAnchor {
            self.leftAnchor.constraint(equalTo: leftAnchor.anchor,
                                       constant: leftAnchor.paddingLeft).isActive = true
        }
        if let rightAnchor = rightAnchor {
            self.rightAnchor.constraint(equalTo: rightAnchor.anchor,
                                        constant: -rightAnchor.paddingRight).isActive = true
        }
        if let bottomAnchor = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottomAnchor.anchor,
                                         constant: -bottomAnchor.paddingBottom-bottomInset).isActive = true
        }
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    func anchorCenter(centerX: NSLayoutXAxisAnchor, centerY: NSLayoutYAxisAnchor,
                      width: CGFloat = 0, height: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    func borderRadius(size: Int) {
        self.layer.cornerRadius = CGFloat(size)
    }
    func borderRadiusAndShadow() {
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = 10.0
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1).cgColor
        clipsToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: 10).cgPath
    }
}

extension Decodable {
    static func parse(jsonFile: String) throws -> Self? {
        guard let urlJson = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
              let dataJson = try? Data(contentsOf: urlJson),
              let output = try? JSONDecoder().decode(self, from: dataJson)
        else {
            throw HandleError.erroParseData
        }
        return output
    }
}

extension URLSession {
    typealias DataTaskResult = Result<(HTTPURLResponse, Data), Error>
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (DataTaskResult) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(HandleError.transportError(error)))
                return
            }
            let response = response as? HTTPURLResponse
            guard let response = response else {
                completionHandler(.failure(HandleError.noData))
                return
            }
            let status = response.statusCode
            guard (200...299).contains(status) else {
                completionHandler(.failure(HandleError.serverSideError("Erro from server")))
                return
            }
            DispatchQueue.main.async {
                completionHandler(.success((response, data!)))
            }
        }
    }
}

extension UIImageView {
    func imageFromUrl(urlAdress: String) {
        guard let urlAdress = URL(string: urlAdress) else {
            return
        }
        URLSession.shared.dataTask(with: urlAdress) { (data, response, _) in
            DispatchQueue.main.async {
                let response = response as? HTTPURLResponse
                let status = response?.statusCode
                guard let imageData = data, let status = status, (200...299).contains(status) else {
                    self.image = UIImage(named: "imgNotFound")
                    self.tintColor = .red
                    return
                }
                self.image = UIImage(data: imageData)
            }
        }.resume()
    }
}

extension UIView {
    class var identifier: String { return String(describing: self) }
}

extension String {
    public var convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,options:
                                            [.documentType: NSAttributedString.DocumentType.html,
                                             .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return nil
        }
    }
    public func convertHtmlToAttributedString(font: UIFont?, alignment: String) -> NSAttributedString? {
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; " +
        "font-size:\(font.pointSize)px; text-align: \(alignment);}</style>\(self)"
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options:
                                            [.documentType: NSAttributedString.DocumentType.html,
                                                .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return nil
        }
    }
}
