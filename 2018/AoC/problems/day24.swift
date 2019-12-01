//
//  day24.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay24 = false

enum DamageType :String {
    case radiation = "radiation"
    case blugdeon = "bludgeoning"
    case slash = "slashing"
    case fire = "fire"
    case cold = "cold"
}

class Group {
    static var boost = 0
    
    let unitDamage :Int
    let unitHP :Int
    let initialUnits :Int
    let weaknesses :[DamageType]
    let immunities :[DamageType]
    let attackType : DamageType
    let initiative :Int
    
    var currentlyTargeted :Bool = false
    var currentTarget :Group? = nil
    var units :Int
    var effectivePower :Int { return units * unitDamage }
    var alive :Bool { return units > 0 }
    
    init(string:String) {
        let firstParts = string.substring(before:"hit points").stringArray(" ")
        let lastParts = string.substring(after:"with an attack").stringArray(" ")
        
        var immune = [DamageType]()
        var weak = [DamageType]()
        if string.contains("(") {
            let middleParts = String(string.split(separator: "(")[1].split(separator: ")")[0]).stringArray(";")
            for part in middleParts {
                if part.hasPrefix("immune to") {
                    part.substring(fromIndex: 9).stringArray(",").forEach { immune.append(DamageType(rawValue: $0)!) }
                } else if part.hasPrefix("weak to") {
                    part.substring(fromIndex: 7).stringArray(",").forEach { weak.append(DamageType(rawValue: $0)!) }
                } else { assertionFailure("unparsable immunity") }
            }
            
        }
        immunities = immune
        weaknesses = weak
        
        units = Int(firstParts[0])!
        initialUnits = units
        unitHP = Int(firstParts[4])!
        
        unitDamage = Int(lastParts[2])! + Group.boost
        attackType = DamageType(rawValue: lastParts[3])!
        initiative = Int(lastParts[7])!
    }
    
    func damageAgainst(_ target:Group) -> Int {
        if target.immunities.contains(attackType) {
            return 0
        } else if target.weaknesses.contains(attackType) {
            return effectivePower * 2
        }
        return effectivePower
    }
    
    func attack() {
        assert(alive, "Dead group attacking")
        guard let target = currentTarget else { assertionFailure("Target mismatch"); return }
        assert(target.alive, "Attacking dead group")
        
        let damage = damageAgainst(target)
        let unitsKilled = min(damage / target.unitHP, target.units)
        target.units -= unitsKilled
//        print("killed \(unitsKilled) units")
    }
    
    func setTarget(_ target:Group) {
        assert(!target.currentlyTargeted)
        self.currentTarget = target
        target.currentlyTargeted = true
    }
    
    static func sortEpInitiative(_ a:Group, _ b:Group) -> Bool {
        if a.effectivePower == b.effectivePower {
            return a.initiative > b.initiative
        }
        return sortEp(a,b)
    }

    static func sortEp(_ a:Group, _ b:Group) -> Bool {
        return a.effectivePower > b.effectivePower
    }
}

class Army {
    let groups :[Group]
    var enemy :Army?
    
    init(groups:[Group]) {
        self.groups = groups
    }
    
    var remainingGroups :[Group] { return groups.filter { $0.alive } }
    var remainingGroupsCount :Int { return groups.count(where:{ $0.alive }) }
    var remainingUnits :Int { return groups.reduce(0) { $1.units + $0 }}
    
    func sortedTargets(of:Group) -> [Group] {
        return groups.filter({$0.alive && !$0.currentlyTargeted && of.damageAgainst($0) > 0}).sorted(by: {
            if of.damageAgainst($0) == of.damageAgainst($1) {
                return Group.sortEpInitiative($0, $1)
            }
            return of.damageAgainst($0) > of.damageAgainst($1)
        })
    }
    
    func chooseTargets() {
        for g in remainingGroups.sorted(by: Group.sortEpInitiative) {
            if let targets = enemy?.sortedTargets(of:g), targets.count > 0 {
                g.setTarget(targets.first!)
            }
        }
    }
    
    func attackingGroups() -> [Group] {
        return  groups.filter { $0.currentTarget != nil }
    }
    
    func resetTargets() {
        groups.forEach {
            $0.currentTarget = nil
            $0.currentlyTargeted = false
        }
    }
}

func immunityBattle(input:String, boost: Int) -> (won:Bool, remaining:Int) {
    let lines = input.lines()
    var immGroups = [Group]()
    var infGroups = [Group]()
    var parsingImmune = true
    for line in lines {
        if line.hasPrefix("Immune System:")  { parsingImmune = true; Group.boost = boost; continue}
        else if line.hasPrefix("Infection:") { parsingImmune = false; Group.boost = 0; continue }
        
        if parsingImmune { immGroups.append(Group(string: line)) }
        else             { infGroups.append(Group(string: line)) }
    }
    
    
    let immune = Army(groups: immGroups)
    let infection = Army(groups: infGroups)
    immune.enemy = infection
    infection.enemy = immune
    
    
    while immune.remainingGroupsCount > 0 && infection.remainingGroupsCount > 0 {
        immune.resetTargets()
        infection.resetTargets()
        
        immune.chooseTargets()
        infection.chooseTargets()
        
//        print("Immune System:"); immune.groups.forEach {if $0.alive {print("contains \($0.units) units")}}
//        print("Infection:"); infection.groups.forEach {if $0.alive {print("contains \($0.units) units")}}
//        print()

//        print("\(immune.remainingUnits) | \(infection.remainingUnits)")
        
        let unitTotal = immune.remainingUnits + infection.remainingUnits
        let attackers = (immune.attackingGroups() + infection.attackingGroups()).sorted(by: { $0.initiative > $1.initiative })
        for g in attackers {
            if g.alive {
                g.attack()
            }
        }
        
        //assert(unitTotal != immune.remainingUnits + infection.remainingUnits, "No units were killed this round")
        if unitTotal == immune.remainingUnits + infection.remainingUnits {
            return (false, 0)
        }

//        print()
    }
    
//    print("\(immune.remainingUnits) | \(infection.remainingUnits)")
    
    if immune.remainingUnits > 0 {
        return (true, immune.remainingUnits)
    } else {
        return (false, infection.remainingUnits)
    }
}

func day24 (_ input:String) -> Solution {
    var solution = Solution()
    solution.partOne = "\(immunityBattle(input: input, boost: 0).remaining)"
    
    var boost = (lose:0, win:2000)
    assert(immunityBattle(input: input, boost: boost.win).won)
    while boost.lose + 1 != boost.win {
        let midpoint = (boost.lose + boost.win) / 2
        let won = immunityBattle(input: input, boost: midpoint).won
        if won { boost = (boost.lose, midpoint) }
        else   { boost = (midpoint, boost.win) }
    }
    solution.partTwo = "\(immunityBattle(input: input, boost: boost.win).remaining)"
    return solution
}
