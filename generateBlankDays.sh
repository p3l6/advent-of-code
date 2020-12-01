#! /bin/bash

for i in $(seq 1 25); do
  cat <<EOF > ./2020/AoC/problems/day$i.swift

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
