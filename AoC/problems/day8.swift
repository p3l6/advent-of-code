//
//  day8.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay8 = false

func day8 (_ input:String) -> Solution {
    var solution = Solution()
    let imageSize = (width: 25, height: 6)
    let imageData :[Int] = input.map { Int(String($0))! }
    let pixelsPerLayer = imageSize.width * imageSize.height
    let numLayers = imageData.count / pixelsPerLayer
    
    if imageData.count % pixelsPerLayer != 0 {
        print("Image layers are not even!")
        exit(1)
    }
    
    enum Pixel: Int {
        case transparent = 2
        case white = 1
        case black = 0
    }
    
    var image = [Pixel](repeating: Pixel.transparent, count: pixelsPerLayer)
    
    var min = (fewestZero: Int.max, mult: 0)
    for l in 0..<numLayers {
        var counts = [0,0,0]
        for p in 0..<pixelsPerLayer {
            let color = Pixel(rawValue:imageData[l*pixelsPerLayer+p])!
            counts[color.rawValue] += 1
            if image[p] == .transparent && color != .transparent {
                image[p] = color
            }
        }
        if counts[0] < min.fewestZero {
            min = (counts[0], counts[1] * counts[2])
        }
    }
    
    solution.partOne = "\(min.mult)"
    
    print("Part two rendering:")
    for row in 0..<imageSize.height {
        for col in 0..<imageSize.width {
            print(image[row*imageSize.width+col] == .white ? "X" : " ", terminator:"")
        }
        print("")
    }
    
    // Manually read from output
    solution.partTwo = "RKHRY"
    return solution
}
