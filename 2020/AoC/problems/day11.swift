
import Foundation

let runDay11 = false

enum WaitingSpace {
    case floor
    case seat
    case occupied
    
    static func fromChar(_ char: Character) -> WaitingSpace {
        switch char {
        case ".": return .floor
        case "L": return .seat
        default: print("[ERROR] Unexpected character in input: \(char)"); return .floor
        }
    }
    
    static func toChar(_ space: WaitingSpace) -> Character {
        switch space {
        case .floor: return "."
        case .seat: return "L"
        case .occupied: return "#"
        }
    }
}

func occupyWaitingArea(grid: FiniteGrid<WaitingSpace>,
                       visibility:FiniteGrid<[Point]>,
                       vacateThreshold: Int) -> (FiniteGrid<WaitingSpace>, Bool) {
    let nextGrid = FiniteGrid(defaultValue: WaitingSpace.floor, area: grid.area)
    nextGrid.grid = grid.grid
    var anyChanges = false
    
    for point in grid.area {
        switch grid[point] {
        case .floor: break
        case .seat:
            if visibility[point].first(where: { grid[$0] == .occupied }) == nil {
                nextGrid[point] = .occupied
                anyChanges = true
            }
        case .occupied:
            if  visibility[point].count(where: { grid[$0] == .occupied }) >= vacateThreshold {
                nextGrid[point] = .seat
                anyChanges = true
            }
        }
    }
    
    return (nextGrid, anyChanges)
}

func day11 (_ input:String) -> Solution {
    var solution = Solution()
    
    var waitingArea: FiniteGrid<WaitingSpace> = FiniteGrid(lines: input.lines(), WaitingSpace.fromChar)
    var anyChanges = true
    
    let visibility = FiniteGrid(defaultValue: [Point](), area: waitingArea.area)
    for point in visibility.area {
        visibility[point] = point.adjacent8().filter { visibility.area.interior($0) }
    }
    
    while anyChanges {
        (waitingArea, anyChanges) = occupyWaitingArea(grid: waitingArea, visibility: visibility, vacateThreshold: 4)
    }
    
    var occupied = waitingArea.area.count(where: { waitingArea[$0] == .occupied })
    solution.partOne = "\(occupied)"
    
    waitingArea = FiniteGrid(lines: input.lines(), WaitingSpace.fromChar)
    anyChanges = true
    
    for point in visibility.area {
        func look(dir: (x:Int,y:Int)) -> Point? {
            var vis = point + dir
            while visibility.area.interior(vis) && waitingArea[vis] != .seat { vis = vis + dir }
            if visibility.area.interior(vis) && waitingArea[vis] == .seat { return vis }
            return nil
        }
        
        var list = [Point]()
        if let vis = look(dir: (1,0)) { list.append(vis) }
        if let vis = look(dir: (-1,0)) { list.append(vis) }
        if let vis = look(dir: (0,1)) { list.append(vis) }
        if let vis = look(dir: (0,-1)) { list.append(vis) }
        if let vis = look(dir: (1,1)) { list.append(vis) }
        if let vis = look(dir: (1,-1)) { list.append(vis) }
        if let vis = look(dir: (-1,1)) { list.append(vis) }
        if let vis = look(dir: (-1,-1)) { list.append(vis) }
        
        visibility[point] = list
    }

    while anyChanges {
        (waitingArea, anyChanges) = occupyWaitingArea(grid: waitingArea, visibility: visibility, vacateThreshold: 5)
    }

    occupied = waitingArea.area.count(where: { waitingArea[$0] == .occupied })
    solution.partTwo = "\(occupied)"
    return solution
}

