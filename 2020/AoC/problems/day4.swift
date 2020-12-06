
import Foundation

let runDay4 = false

struct Passport {
    var byr: String? = nil
    var iyr: String? = nil
    var eyr: String? = nil
    var hgt: String? = nil
    var hcl: String? = nil
    var ecl: String? = nil
    var pid: String? = nil
    var cid: String? = nil
    
    let colorCharSet = CharacterSet(charactersIn: "#abcdef0123456789")
    
    init(data: String) {
        let keyValues: [(String, String)] = data
            .stringArray(" ")
            .map { field in let kv = field.stringArray(":"); return (key:kv[0], val:kv[1]) }
        for (key, val) in keyValues {
            if key == "byr" { byr = val }
            if key == "iyr" { iyr = val }
            if key == "eyr" { eyr = val }
            if key == "hgt" { hgt = val }
            if key == "hcl" { hcl = val }
            if key == "ecl" { ecl = val }
            if key == "pid" { pid = val }
            if key == "cid" { cid = val }
        }
    }
    
    var fieldsExist: Bool {
        return byr != nil && iyr != nil && eyr != nil &&
            hgt != nil && hcl != nil && ecl != nil && pid != nil
    }
    
    var valid: Bool {
        guard fieldsExist else { return false }
        guard let byr = byr, byr.count == 4, let byri = Int(byr), 1920 <= byri, byri <= 2002 else { return false }
        guard let iyr = iyr, iyr.count == 4, let iyri = Int(iyr), 2010 <= iyri, iyri <= 2020 else { return false }
        guard let eyr = eyr, eyr.count == 4, let eyri = Int(eyr), 2020 <= eyri, eyri <= 2030 else { return false }
        guard let hcl = hcl, hcl.hasPrefix("#"), hcl.count == 7, hcl.trimmingCharacters(in: colorCharSet).count == 0 else { return false }
        guard let ecl = ecl, ["amb","blu","brn","gry","grn","hzl","oth"].contains(where: {$0==ecl}) else { return false }
        guard let pid = pid, pid.count == 9, pid.trimmingCharacters(in: .decimalDigits).count == 0 else { return false }
        
        guard let hgt = hgt else { return false }
        if hgt.hasSuffix("in") {
            guard let inch = Int(hgt.substring(before: "in")) else { return false }
            if inch < 59 || 76 < inch { return false }
        } else if hgt.hasSuffix("cm") {
            guard let cm = Int(hgt.substring(before: "cm")) else { return false }
            if cm < 150 || 193 < cm { return false }
        } else { return false }
        
        return true
    }
}

func day4 (_ input:String) -> Solution {
    var solution = Solution()
    let lineGroups = input.lineGroups()
    let passports = lineGroups.map { Passport(data: $0.joined(separator: " ")) }
    
    solution.partOne = "\(passports.count() { $0.fieldsExist })"
    solution.partTwo = "\(passports.count() { $0.valid })"
    return solution
}

