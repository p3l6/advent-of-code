
import Foundation

let runDay18 = false

func tokenize(_ formula: String) -> [String] {
    var tokens = [String]()
    var parenLevel = 0
    var token = ""
    for element in formula.stringArray(" ") {
        if parenLevel > 0 {
            parenLevel += element.count(where: { $0 == "(" })
            parenLevel -= element.count(where: { $0 == ")" })
            token += " \(element)"
            
            if parenLevel == 0 {
                tokens.append(token)
            }
        } else if element.hasPrefix("(") {
            parenLevel += element.count(where: { $0 == "(" })
            token = element
        } else {
            tokens.append(element)
        }
    }
    return tokens
}

func evaluateFormula(_ formula: String) -> Int {
    var accum = 0
    var add = true
    
    for token in tokenize(formula) {
        if token.hasPrefix("(") {
            var parenContents = token
            parenContents.removeLast()
            parenContents.removeFirst()
            let value = evaluateFormula(parenContents)
            accum = add ? accum + value : accum * value
        } else if let value = Int(token) {
            accum = add ? accum + value : accum * value
        } else if token == "+" {
            add = true
        } else if token == "*" {
            add = false
        } else {
            print("[Error] Unexpected token: \(token)")
        }
    }
    
    return accum
}

func day18 (_ input:String) -> Solution {
    var solution = Solution()
    let formulas = input.lines()
    solution.partOne = "\(formulas.map { evaluateFormula($0) }.sum())"
//    solution.partTwo = "\(formulas.map { evaluateFormula(wrapPlus($0)) }.sum())"
    return solution
}

