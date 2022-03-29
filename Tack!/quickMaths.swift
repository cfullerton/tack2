//
//  quickMaths.swift
//  Tack!
//
//  Created by Conner Fullerton on 10/13/21.
//

import Foundation

public class LiftHead {
    var angle = 0
    var total = 0
    var type = "+"
    func stringify() -> String {
        if angle == 0 {
            return "0"
        }else {
            return type + String(angle)
        }
    }
}

public class QuickMaths {
    var markHeading = 400
    var tackingAngle = 45
    var lastHeading = 0
    var minutes = 5
    var seconds = 0
    var timeMode = false
    func vmg(speed:Double) -> Double {
        let currentAngle = offAngle(angle: lastHeading)
        return speed * cos(Double(currentAngle.total) * Double.pi / 180)
    }
    func offAngle(angle:Int) -> LiftHead {
        let liftHead = LiftHead()
        if markHeading > 361 {
            return liftHead
        }else{
            var angleOff = abs((angle - markHeading + 360) % 360); //amount lifted or headed
            if (angleOff > 180)
            {
                angleOff = 360 - angleOff;
            }
            liftHead.total = angleOff
            let liftAmount = abs(tackingAngle-angleOff);
            liftHead.angle = liftAmount
            if (angleOff > tackingAngle)
            {
                liftHead.type = "-"
                
            }else{
                liftHead.type = "+"
            }
            return liftHead
        }
    }
}
