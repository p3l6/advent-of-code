
import Foundation
import Shared

@main @dayMain struct DayRunner: Runnable {
    let dayNumber = 5
    let tests = [
        TestCase("""
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
""", .both(35, 46))
    ]
}



struct CategoryMaps {
    struct CategoryMap {
        let ranges: [(dest: Int, source: Int, size: Int)]

        init(lineGroup: [String]) {
            // first line is header
            ranges = lineGroup.dropFirst().map {
                let n = $0.split(separator: " ").map(String.init).map { Int($0)! }
                return (n[0], n[1], n[2])
            }
        }


        func convert(_ num: Int) -> Int { 
            for range in ranges {
                if range.source <= num && num < range.source + range.size {
                    return range.dest + num - range.source
                }
            }
            return num
        }
    }

    let seedSoil: CategoryMap
    let soilFertilizer: CategoryMap
    let fertilizerWater: CategoryMap
    let waterLight: CategoryMap
    let lightTemp: CategoryMap
    let tempHumidity: CategoryMap
    let humidityLocation: CategoryMap
}

struct Seed {
    let seed: Int
    let soil: Int
    let fertilizer: Int
    let water: Int
    let light: Int
    let temp: Int
    let humidity: Int
    let location: Int

    init(number: Int, _ maps: CategoryMaps) {
        seed = number
        soil = maps.seedSoil.convert(seed)
        fertilizer = maps.soilFertilizer.convert(soil)
        water = maps.fertilizerWater.convert(fertilizer)
        light = maps.waterLight.convert(water)
        temp = maps.lightTemp.convert(light)
        humidity = maps.tempHumidity.convert(temp)
        location = maps.humidityLocation.convert(humidity)
    }
}

func day(_ input: Input) -> Answer {
    let sections = input.lineGroups

    let maps = CategoryMaps(
        seedSoil: CategoryMaps.CategoryMap(lineGroup: sections[1]),
        soilFertilizer: CategoryMaps.CategoryMap(lineGroup: sections[2]),
        fertilizerWater: CategoryMaps.CategoryMap(lineGroup: sections[3]),
        waterLight: CategoryMaps.CategoryMap(lineGroup: sections[4]),
        lightTemp: CategoryMaps.CategoryMap(lineGroup: sections[5]),
        tempHumidity: CategoryMaps.CategoryMap(lineGroup: sections[6]),
        humidityLocation: CategoryMaps.CategoryMap(lineGroup: sections[7])
    )

    let seedNumbers = sections[0][0]
        .trimmingPrefix(/seeds: +/)
        .split(separator: " ")

    let fewSeeds = seedNumbers
        .map { Int(String($0))! }
        .map { Seed(number: $0, maps) }
        .map(\.location)

    // Part 2 has too many seeds to check, there must be an optimization hidden here.

    return .one(fewSeeds.min()!)
}
