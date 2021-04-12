//
//  RandomGenerator.swift
//  paintsplash
//
//  Created by admin on 12/4/21.
//

import GameplayKit

protocol RandomGenerator {
    var seed: UInt64 { get }

    func nextInt(_ range: Range<Int>) -> Int
    func nextUniform(_ range: Range<Double>) -> Double
    func nextBool() -> Bool
}

class RandomNumber: RandomGenerator {
    let source: GKLinearCongruentialRandomSource
    let seed: UInt64

    init(_ seed: UInt64) {
        source = GKLinearCongruentialRandomSource(seed: seed)
        self.seed = seed
    }

    func nextInt(_ range: Range<Int>) -> Int {
        let size = range.upperBound - range.lowerBound
        let random = source.nextInt(upperBound: size) + range.lowerBound
        assert(range.contains(random))
        return random
    }

    func nextUniform(_ range: Range<Double>) -> Double {
        let size = range.upperBound - range.lowerBound
        let random = source.nextUniform()
        let randomDouble = (Double(random) * size) + range.lowerBound
        assert(range.contains(randomDouble))
        return randomDouble
    }

    func nextBool() -> Bool {
        source.nextBool()
    }
}
