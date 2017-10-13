//
//  LineEquationTests.swift
//  MathTests
//
//  Created by yyjim on 13/10/2017.
//  Copyright © 2017 Cardinalblue. All rights reserved.
//

import XCTest

@testable import Math

class LineEquationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLines() {
        _ = { () -> Void in
            // -- Equation: y = x
            let (p1, p2) = (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
            let lineEq = LineEquation(p1: p1, p2: p2)
            
            // -- Test slope
            XCTAssertEqual(lineEq.slope, 1)
            
            // -- Test x and y
            let points: [CGFloat] = [1, 1.5, 2]
            for p in points {
                XCTAssertEqual(lineEq.x(ofY: p), p)
                XCTAssertEqual(lineEq.y(ofX: p), p)
            }
            
            // -- Test distance
            let d = lineEq.distance(toX: 1, y: 0)
            XCTAssertEqual(d, sqrt(0.5), accuracy: 5)
        }()
            
        _ = { () -> Void in
            // -- Equation: y = 3x + 2
            let (p1, p2) = (CGPoint(x: 0, y: 2), CGPoint(x: 1, y: 5))
            let lineEq = LineEquation(p1: p1, p2: p2)
            
            // -- Test slope
            XCTAssertEqual(lineEq.slope, 3)
            XCTAssertEqual(lineEq.y_intercept, 2)
            XCTAssertEqual(lineEq.x_intercept, -2 / 3)

            XCTAssertEqual(lineEq.y(ofX: 0), 2)
            XCTAssertEqual(lineEq.y(ofX: 1), 5)
            XCTAssertEqual(lineEq.x(ofY: 2), 0)
            XCTAssertEqual(lineEq.x(ofY: 5), 1)
            
            XCTAssertEqual(lineEq.x(ofY: 0), -2 / 3, accuracy: 5)
            XCTAssertEqual(lineEq.y(ofX: 2), 8)
        }()
    }
    
    func testParallelAxisLines() {
        _ = { () -> Void in
            // -- Equation: y = 3
            let (p1, p2) = (CGPoint(x: 0, y: 3), CGPoint(x: 5, y: 3))
            let lineEq = LineEquation(p1: p1, p2: p2)
            
            // -- Test slope
            XCTAssertEqual(lineEq.slope, 0)
            
            // -- Test x and y
            XCTAssertEqual(lineEq.y(ofX: 0), 3)
            XCTAssertEqual(lineEq.y(ofX: 1), 3)
            XCTAssertTrue(lineEq.x(ofY: 3).isNaN)
            XCTAssertTrue(lineEq.x(ofY: 5).isNaN)

            // -- Test distance
            let points: [(CGFloat, CGFloat)] = [(1, 0), (1, 1), (3, 3), (4, 5)]
            for (x, y) in points {
                let d = lineEq.distance(toX: x, y: y)
                XCTAssertEqual(d, fabs(y - 3))
            }
        }()
        
        _ = { () -> Void in
            // -- Equation: x = 1
            let (p1, p2) = (CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 5))
            let lineEq = LineEquation(p1: p1, p2: p2)
            
            // -- Test slope
            XCTAssertEqual(lineEq.slope, CGFloat.infinity)
            
            // -- Test x and y
            XCTAssertTrue(lineEq.y(ofX: 0).isNaN)
            XCTAssertTrue(lineEq.y(ofX: 1).isNaN)
            XCTAssertEqual(lineEq.x(ofY: 3), 1)
            XCTAssertEqual(lineEq.x(ofY: 5), 1)

            // -- Test distance
            let points: [(CGFloat, CGFloat)] = [(1, 0), (1, 1), (3, 3), (4, 5)]
            for (x, y) in points {
                let d = lineEq.distance(toX: x, y: y)
                XCTAssertEqual(d, fabs(x - 1))
            }
        }()
    }
    
    func testShiftLines() {
        // Shift y = 1 to {1, 5}
        _ = { () -> Void in
            let lineEq = LineEquation(p1: CGPoint(x:0, y:1), p2: CGPoint(x: 2, y: 1))
            XCTAssertEqual(lineEq.slope, 0)
            
            // The new line equation should be y = 5
            let shiftedLineEq = lineEq.shift(to: CGPoint(x: 1, y: 5))
            
            // -- Test coefficient
            XCTAssertEqual(shiftedLineEq.slope, 0)
            XCTAssertEqual(shiftedLineEq.y_intercept, 5)
            XCTAssertTrue(shiftedLineEq.x_intercept.isNaN)

            // -- Test x and y
            XCTAssertEqual(shiftedLineEq.y(ofX:  5), 5)
            XCTAssertEqual(shiftedLineEq.y(ofX: 10), 5)
            XCTAssertTrue (shiftedLineEq.x(ofY:  5).isNaN)
            XCTAssertTrue (shiftedLineEq.x(ofY: 10).isNaN)
        }()

        // Shift x = 1 to {5, 1}
        _ = { () -> Void in
            let lineEq = LineEquation(p1: CGPoint(x:1, y:0), p2: CGPoint(x: 1, y: 1))
            XCTAssertEqual(lineEq.slope, CGFloat.infinity)
            
            // The new line equation should be x = 5
            let shiftedLineEq = lineEq.shift(to: CGPoint(x: 5, y: 1))
            
            // -- Test coefficient
            XCTAssertEqual(shiftedLineEq.slope, CGFloat.infinity)
            XCTAssertEqual(shiftedLineEq.x_intercept, 5)
            XCTAssertTrue(shiftedLineEq.y_intercept.isNaN)
            
            // -- Test x and y
            XCTAssertEqual(shiftedLineEq.x(ofY:  5), 5)
            XCTAssertEqual(shiftedLineEq.x(ofY: 10), 5)
            XCTAssertTrue (shiftedLineEq.y(ofX:  5).isNaN)
            XCTAssertTrue (shiftedLineEq.y(ofX: 10).isNaN)
        }()
        
        // Shift y = x to {1, 5}
        _ = { () -> Void in
            let lineEq = LineEquation(p1: CGPoint(x:1, y:1), p2: CGPoint(x: 2, y: 2))
            XCTAssertEqual(lineEq.slope, 1)
            
            // The new line equation should be y = x + 4
            let shiftedLineEq = lineEq.shift(to: CGPoint(x: 1, y: 5))
            
            // -- Test coefficient
            XCTAssertEqual(shiftedLineEq.slope, 1)
            XCTAssertEqual(shiftedLineEq.y_intercept, 4)
            XCTAssertEqual(shiftedLineEq.x_intercept, -4)
            
            // -- Test x and y
            XCTAssertEqual(shiftedLineEq.x(ofY:  0), -4)
            XCTAssertEqual(shiftedLineEq.x(ofY:  5), 1)
            XCTAssertEqual(shiftedLineEq.y(ofX:  0), 4)
            XCTAssertEqual(shiftedLineEq.y(ofX:  5), 9)
        }()
    }
    
}
