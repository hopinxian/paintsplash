//
//  LinkedList.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

public class LinkedList<T> {
    var data: T
    var next: LinkedList?
    public init(data: T){
        self.data = data
    }
}
