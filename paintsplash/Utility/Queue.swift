//
//  Queue.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class Queue<T> {
    typealias LLNode = LinkedList<T>

    var head: LLNode!

    public var isEmpty: Bool { return head == nil }

    var first: LLNode? { return head }

    var last: LLNode? {
        if var node = self.head {
            while case let next? = node.next {
                node = next
            }
            return node
        } else {
            return nil
        }
    }

    func enqueue(_ item: T) {
        let nextItem = LLNode(data: item)
        if let lastNode = last {
            lastNode.next = nextItem
        } else {
            head = nextItem
        }
    }
    func dequeue() -> T? {
        guard self.head?.data != nil else {
            return nil
        }

        if let nextItem = self.head?.next {
            head = nextItem
        } else {
            head = nil
        }
        
        return head?.data
    }
}
