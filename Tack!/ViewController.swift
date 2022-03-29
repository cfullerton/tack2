//
//  ViewController.swift
//  Tack!
//
//  Created by Conner Fullerton on 10/13/21.
//

import UIKit
import Foundation
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let quickMaths = QuickMaths()
    let startLine = StartLine()
    @IBOutlet weak var ttl: UILabel!
    @IBOutlet weak var dist: UILabel!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var off: UILabel!
    @IBOutlet weak var pin: UIButton!
    @IBOutlet weak var boat: UIButton!
    @IBOutlet weak var shot: UIButton!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var toggleLabel: UILabel!
    @IBOutlet weak var vmgLabel: UILabel!
    @IBOutlet weak var gun: UIButton!
    @IBOutlet weak var compassToggle: UISwitch!
    var timer:Timer? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CLLocationManager.headingAvailable()){
            locationManager.headingFilter = 1
            locationManager.startUpdatingHeading()
            locationManager.delegate = self
        }
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if compassToggle.isOn {
            quickMaths.lastHeading = Int(newHeading.magneticHeading)
            if !quickMaths.timeMode{
                heading.text = String(Int(newHeading.magneticHeading))
            }
            off.text = quickMaths.offAngle(angle: Int(newHeading.magneticHeading)).stringify()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        speedLabel.text = String(format: "%.2f", locations.last?.speed ?? 0 * 1.94384) + "kn"
        if !compassToggle.isOn {
            quickMaths.lastHeading = Int(locations.last?.course ?? 0)
            if !quickMaths.timeMode{
                heading.text = String(Int(locations.last?.course ?? 0))
            }
            off.text = quickMaths.offAngle(angle: Int(locations.last?.course ?? 0)).stringify()
        }
        vmgLabel.text = String(format: "%.2f", quickMaths.vmg(speed: locations.last?.speed ?? 0) * 1.94384)
        if startLine.set(){
            dist.text = String(format: "%.2f",startLine.dist(currentLocation: locations.last ?? CLLocation(latitude: 0, longitude: 0))) + "m"
            ttl.text = String(startLine.time(currentLocation: locations.last ?? CLLocation(latitude: 0, longitude: 0))) + "s"
        }else{
            print("line not set")
        }
    }
    
    @IBAction func shotClick(_ sender: Any) {
        quickMaths.markHeading = Int(locationManager.heading?.magneticHeading ?? 400)
    }
    
    @IBAction func pinClick(_ sender: Any) {
        startLine.pin = locationManager.location
    }
    @IBAction func gunClick(_ sender: Any) {
        if !quickMaths.timeMode{
            quickMaths.timeMode = true
            gun.titleLabel?.text = "Sync"
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        }
        
    }
    @IBAction func boatClick(_ sender: Any) {
        startLine.boat = locationManager.location
    }
    @IBAction func compassToggleChange(_ sender: Any) {
        if compassToggle.isOn {
            toggleLabel.text = "Compass"
        }else {
            toggleLabel.text = "GPS Heading"
        }
    }
    @objc func fireTimer() {
        if (quickMaths.minutes > 0){
            if (quickMaths.seconds==0){
                quickMaths.minutes -= 1
                quickMaths.seconds=59
            }else if (quickMaths.seconds > 0){
                    quickMaths.seconds -= 1
                }
            if (quickMaths.timeMode) {
                heading.text = String(format: "%d:%02d" ,quickMaths.minutes,quickMaths.seconds) ;

                }
            }else {
                if (quickMaths.seconds == 0){
                    timer?.invalidate();
                    quickMaths.minutes = 5;
                    quickMaths.seconds = 0;
                    quickMaths.timeMode = false;
                    gun.titleLabel?.text = "Gun"
                }else if (quickMaths.seconds > 0){
                    quickMaths.seconds -= 1;
                    heading.text = String(format: "%d:%d",quickMaths.minutes,quickMaths.seconds)
                }
            }
    }
}

