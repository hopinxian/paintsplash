//
//  RandomGenerator.swift
//  paintsplash
//
//  Created by admin on 12/4/21.
//

import GameplayKit

/**
 `RandomGenerator` is a type that can generate random values.
 It is seeded so that random values can be replicated if need be.
 */
protocol RandomGenerator {
    var seed: UInt64 { get }

    /// Generates a random integer from the range of integers given.
    func nextInt(_ range: Range<Int>) -> Int

    /// Generates a random double from the range of doubles given.
    func nextUniform(_ range: Range<Double>) -> Double

    /// Generates a random boolean.
    func nextBool() -> Bool
}

/**
 `RandomNumber` generates random numbers using the linear congruential generator algorithm.
 */
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
