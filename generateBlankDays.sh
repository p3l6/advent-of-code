#! /bin/bash

year=2020

for i in $(seq 1 25); do
  cat <<EOF > ./$year/AoC/problems/day$i.swift

import Foundation

let runDay$i = false

func day$i (_ input:String) -> Solution {
    let solution = Solution()
//    solution.partOne = "\()"
//    solution.partTwo = "\()"
    return solution
}

EOF

cat <<EOF >> ./$year/AocTest/AocTest.swift
// class Day${i}Tests: AocTest { override var problem:Problem{return day$i}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

EOF
done
