// swiftlint:disable:this file_name
//  CodableExtensions.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
            .flatMap { $0 as? [String: Any] }
    }
}

extension Decodable {
    init?(from: [String: Any]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: from, options: .fragmentsAllowed)
            let decoder = JSONDecoder()
            self = try decoder.decode(Self.self, from: data)
        } catch {
            return nil
        }
    }
}
