//
//  BidirectionalMap.swift
//  paintsplash
//
//  Created by Farrell Nah on 23/3/21.
//

class BidirectionalMap<F: Hashable, T: Hashable> {
    private var _forward: [F: T]?
    private var _backward: [T: F]?

    var forward: [F: T] {
        get {
            _forward = _forward ?? [F: T](uniqueKeysWithValues: _backward?.map {($1, $0)} ?? [] )
            return _forward!
        }
        set { _forward = newValue; _backward = nil }
    }

    var backward: [T: F] {
        get {
            _backward = _backward ?? [T: F](uniqueKeysWithValues: _forward?.map {($1, $0)} ?? [] )
            return _backward!
        }
        set { _backward = newValue; _forward = nil }
    }

    init(_ dict: [F: T] = [:]) { forward = dict  }

    init(_ values: [(F, T)]) { forward = [F: T](uniqueKeysWithValues: values) }

    subscript(_ key: T) -> F? {
        get { return backward[key] }
        set { backward[key] = newValue }
    }

    subscript(_ key: F) -> T? {
        get { return forward[key]  }
        set { forward[key]  = newValue }
    }

    subscript(to key: T) -> F? {
        get { return backward[key] }
        set { backward[key] = newValue }
    }

    subscript(from key: F) -> T? {
        get { return forward[key]  }
        set { forward[key]  = newValue }
    }

    var count: Int { return _forward?.count ?? _backward?.count ?? 0 }
}
