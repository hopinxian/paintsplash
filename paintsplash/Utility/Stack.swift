//
//  Stack.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class Stack<T: Ammo> {
    var items = [T]()

    func push(_ item: T) {
        items.append(item)
    }

    func pop() -> T? {
        let last = items.last

        if last != nil {
            items.removeLast()
        }

        return last
    }
}
