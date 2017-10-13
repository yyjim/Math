//
//  LineEquation.swift
//  Math
//
//  Created by yyjim on 13/10/2017.
//  Copyright © 2017 Cardinalblue. All rights reserved.
//

import Foundation
import UIKit

struct LineEquation {
    
    var slope: CGFloat = .nan
    var y_intercept: CGFloat = .nan
    var x_intercept: CGFloat = .nan
    
    init(slope: CGFloat, point: CGPoint) {
        self.slope = slope
        switch slope {
        case CGFloat.infinity:
            x_intercept = point.x
            y_intercept = .nan
        case 0:
            x_intercept = .nan
            y_intercept = point.y
        default:
            // y = mx + b => b = y - mx
            y_intercept = point.y - slope * point.x
            x_intercept = -y_intercept / slope
        }
    }
    
    init(p1: CGPoint, p2: CGPoint) {
        let (slope, y_intercept, x_intercept) = calculateLineEquation(ofP1: p1, p2: p2)
        self.slope       = slope
        self.y_intercept = y_intercept
        self.x_intercept = x_intercept
    }
    
    private func calculateLineEquation(ofP1 p1:CGPoint, p2: CGPoint) -> (CGFloat, CGFloat, CGFloat) {
        /*
         m = (y - y') / (x - x')
         
         The Point-Slope Form
         y - y' = m(x - x')
         y = m(x - x') + y'
         y = mx - m * p.x + p.y
         y = mx + b
         
         b = y_intercept (x = 0) = p.y - m * p.x
             x_intercept (y = 0) = -b / m
         */
        if (p2.x == p1.x) {
            return (CGFloat.infinity, .nan, p1.x)
        }
        if (p2.y == p1.y) {
            return (0, p1.y, .nan)
        }
        let m = (p2.y - p1.y) / (p2.x - p1.x)
        let b = -m * p2.x + p2.y
        let c = -b / m
        return (m, b, c)
    }
    
    func x(ofY y: CGFloat) -> CGFloat {
        // parallel y-axis
        if slope == CGFloat.infinity {
            return x_intercept
        } else if slope == 0 {
            return .nan
        }
        return (y - y_intercept) / slope
    }
    
    func y(ofX x: CGFloat) -> CGFloat {
        // parallel x-axis
        if slope == 0 {
            return y_intercept
        } else if slope == .infinity {
            return .nan
        }
        return slope * x + y_intercept
    }
    
    // https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line
    func distance(toX x: CGFloat, y: CGFloat) -> CGFloat {
        // Equation:
        // y = mx + b => mx - y + b = 0
        // Distance(ax + by + c = 0, x, y) = abs( ax + by + c) / sqrt(a^2 + b^2),
        // where `a`, `b` and `c` are real constants with `a` and `b` not both zero
        var coefficient: (CGFloat, CGFloat, CGFloat)
        switch slope {
        case CGFloat.infinity:
            coefficient = (1, 0, -x_intercept)
        case 0:
            coefficient = (0, 1, -y_intercept)
        default:
            coefficient = (slope, CGFloat(-1.0), y_intercept)
        }
        
        let (a, b, c) = coefficient
        if a == 0 && b == 0 {
            return .nan
        }
        let distance = fabs(a * x + b * y + c) / sqrt(a * a + b * b)
        return distance
    }
    
    func shift(to point: CGPoint) -> LineEquation {
        switch slope {
        // parallel y-axis
        case CGFloat.infinity:
            let p1 = CGPoint(x: point.x, y: 0)
            let p2 = CGPoint(x: point.x, y: 1)
            return LineEquation(p1: p1, p2: p2)
        // parallel x-axis
        case 0:
            let p1 = CGPoint(x: 0, y: point.y)
            let p2 = CGPoint(x: 1, y: point.y)
            return LineEquation(p1: p1, p2: p2)
        default:
            return LineEquation(slope: slope, point: point)
        }
    }
}

