//
//  startLine.swift
//  Tack!
//
//  Created by Conner Fullerton on 10/13/21.
//

import Foundation
import CoreLocation

public class StartLine {
    var pin : CLLocation? = nil
    var boat : CLLocation? = nil
    func set() -> Bool{
        if (pin != nil) && (boat != nil) {
            return true
        }else{
            return false
        }
    }
    func time(currentLocation:CLLocation) -> Int {
        let distance = dist(currentLocation: currentLocation)
        if currentLocation.speed > 0 {
            return Int(distance / currentLocation.speed)
        }else{
            return 999
        }
        
    }
    func dist(currentLocation:CLLocation) -> Double {
        var distance = 0.0
        var linePoint = [0.0,0.0]
        if (pin != nil){
            linePoint = closestPnt(x: pin?.coordinate.latitude ?? 0, y: pin?.coordinate.longitude ?? 0, x1: boat?.coordinate.latitude ?? 0, y1: boat?.coordinate.longitude ?? 0, px: currentLocation.coordinate.latitude, py: currentLocation.coordinate.longitude)
        }
        let lineIntLocation = CLLocation(latitude: linePoint[0], longitude: linePoint[1])
        distance = currentLocation.distance(from: lineIntLocation)
        return distance
    }
    func closestPnt(x: Double, y: Double, x1: Double, y1: Double, px: Double, py: Double)->[Double]{
        let vx = x1 - x  // vector of line
        let vy = y1 - y
        let ax = px - x  // vector from line start to point
        let ay = py - y
        let u = (ax * vx + ay * vy) / (vx * vx + vy * vy) // unit distance on line
        if u >= 0 && u <= 1 {                             // is on line segment
            return [x + vx * u, y + vy * u]               // return closest point on line
        }
        if u < 0 {
            return [x, y]      // point is before start of line segment so return start point
        }
        return [x1, y1]       // point is past end of line so return end
    }
}
