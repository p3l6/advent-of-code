//
//  problem.swift
//  AoC
//
//  Created by Paul Landers on 11/8/18.
//

import Foundation

let problemDay = 4

class Guard :Equatable {
    struct Date :Comparable{
        static func < (lhs: Guard.Date, rhs: Guard.Date) -> Bool {
            if lhs.month == rhs.month {
                if lhs.day == rhs.day {
                    if lhs.hour == rhs.hour {
                        return lhs.minute < rhs.minute
                    } else {
                        return lhs.hour < rhs.hour
                    }
                } else {
                    return lhs.day < rhs.day
                }
            } else {
                return lhs.month < rhs.month
            }
        }
        
        let month :Int
        let day :Int
        let hour :Int
        let minute :Int
    }
    
    enum EventType {
        case ToSleep
        case WakeUp
    }
    
    struct Event {
        let type : EventType
        let date : Date
    }
    
    let id: Int
    var events = [Event]()
    
    init(id:Int) {
        self.id = id
    }
    
    func addEvent (_ t:EventType, _ d :Date) {
        events.append(Event(type: t, date: d))
    }
    
    static func == (lhs: Guard, rhs: Guard) -> Bool { return lhs.id == rhs.id }
    
    private var _sleepTime :Int? = nil
    private var _asleepMins = [Int](repeating: 0, count: 60)
    var sleepTime :Int {
        if let s = _sleepTime  {
            return s
        }
        
        var total = 0
        var sortedEvents = events.sorted(by: { (left,right) -> Bool in return left.date < right.date })
        
        while sortedEvents.count > 0 {
            let asleep = sortedEvents.removeFirst()
            let awake = sortedEvents.removeFirst()
            assert(asleep.type == .ToSleep)
            assert(awake.type == .WakeUp)
            total += awake.date.minute - asleep.date.minute
            for i in asleep.date.minute..<awake.date.minute {
                _asleepMins[i] += 1
            }
        }
        
        _sleepTime = total
        return total
    }
    
    func maxMinute() -> (minute:Int,times:Int) {
        var index = 0
        for i in 0..<60 {
            if _asleepMins[i] > _asleepMins[index] {
                index = i
            }
        }
        return (index,_asleepMins[index])
    }
}

func problem(_ input:String) -> Solution {
    var solution = Solution()
    
    var guards = [Int:Guard]()
    var currentGaurd = Guard(id:-1)
    
    for line in input.lines().sorted() {
        let parts = line.split(separator: "]")
        let dComps = String(parts[0]).extract(format: "[1518-%-% %:%")!
        let eventDate = Guard.Date(month: dComps[0], day: dComps[1], hour: dComps[2], minute: dComps[3])
        if let id = String(parts[1]).extract(format: " Guard #% begins shift")?.first {
            if guards[id] == nil {
                guards[id] = Guard(id: id)
            }
            currentGaurd = guards[id]!
        } else if parts[1] == " falls asleep" {
            currentGaurd.addEvent(.ToSleep, eventDate)
        } else if parts[1] == " wakes up" {
            currentGaurd.addEvent(.WakeUp, eventDate)
        } else {
            print("could not parse line!")
        }
    }
    
    var gMax = Guard(id:-1)
    for g in guards.values {
        if g.sleepTime > gMax.sleepTime {
            gMax = g
        }
    }
    
    solution.partOne = "\(gMax.id * gMax.maxMinute().minute)"
    
    gMax = Guard(id:-1)
    for g in guards.values {
        if g.maxMinute().times > gMax.maxMinute().times {
            gMax = g
        }
    }
    
    solution.partTwo = "\(gMax.id * gMax.maxMinute().minute)"
    
    return solution
}
