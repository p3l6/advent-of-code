#! /bin/bash

for i in $(seq 1 25); do
  cat <<EOF > ./AoC/problems/day$i.swift
//
//  day$i.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay$i = false

func day$i (_ input:String) -> Solution {
    let solution = Solution()
//    solution.partOne = "\()"
//    solution.partTwo = "\()"
    return solution
}
EOF
done
