//
//  constants.swift
//  AoC
//
//  To create all days from a template day1.swift:
//    for i in $(seq 2 25); do cat day1.swift | sed "s/1/$i/g" > day$i.swift; done

import Foundation

typealias Problem = (String) -> Solution

let overrideRange :ClosedRange<Int>? /* */ = nil // */ = 1...4
//    remove these chars to use range   ^^

let localFolder = "/Users/paul/var/AdventOfCode"
let cacheFolderName = "Cache"
let pageDumpFolderName = "RawHttp"
let urlBase = "https://adventofcode.com/2018"

let manualInput =
"""
Paste input here if token can't be used
"""
