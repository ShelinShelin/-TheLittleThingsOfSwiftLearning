//: Playground - noun: a place where people can play

import UIKit

protocol Petrolable {
    var volume: Double {get}
    func puttingPetrol()
}

protocol Electricable {
    var chargingDuration: Double {get}
    func charging()
}

extension Electricable {
    var chargingDuration: Double {
        return 5.0
    }
    
    func charging() {
        print("特斯拉已经充电\(chargingDuration)小时了")
    }
}

extension Petrolable {
    var volume: Double {
        return 100.0
    }
    
    func puttingPetrol() {
        print("这辆皮卡刚才加了\(volume)升油")
    }
}

//电动
struct Tesla: Electricable{

//    func charging() {
//        print("\(name)--充电")
//    }
}

//油动力
struct Pickup: Petrolable {

//    func puttingPetrol() {
//        print("\(name)--加油")
//    }
}

let tesla = Tesla()
tesla.charging()

let ford = Pickup()
ford.puttingPetrol()

//混合动力
struct Hybrid {
    
}
