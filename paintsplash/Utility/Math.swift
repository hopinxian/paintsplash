//
//  Math.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 14/3/21.
//

/**
 `Math` contains useful utility functions.
 */
struct Math {
    /// Returns the greatest common divisor among the given array of integers.
    /// The array of integers must not be empty.
    static func getGCD(numbers: [Int]) -> Int {
        assert(!numbers.isEmpty)

        var gcd = numbers[0]
        for i in 1..<numbers.count {
            gcd = getGCD(gcd, numbers[i])
        }

        return gcd
    }

    /// Returns the greatest common divisor between the given non-negative integers.
    static func getGCD(_ lhs: Int, _ rhs: Int) -> Int {
        assert(lhs >= 0 && rhs >= 0)

        var big = max(lhs, rhs)
        var small = min(lhs, rhs)
        while small != 0 {
            let temp = big % small
            big = small
            small = temp
        }

        return big
    }
}
