import Foundation

public struct Loc: Hashable {
    let row, col: Int
    public init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}

public protocol GridProtocol<Element> {
    associatedtype Element
    subscript (_ at: Loc) -> Element { get set }
    var boundary: Loc { get }
    func locInTopGrid(_ loc: Loc) -> Loc
}

public extension GridProtocol {
    func subgrid(from: Loc, to: Loc) -> SubGrid<Element> { SubGrid(inside: self, from: from, to: to) }
    
    func iterator() -> GridIterator<Element> {
        GridIterator(self)
    }
}

public struct GridIterator<GridElement>: IteratorProtocol, Sequence {
    let grid: any GridProtocol<GridElement>
    var currentLoc = Loc(row: 0, col: -1)

    init(_ grid: any GridProtocol<GridElement>) {
        self.grid = grid
    }

    mutating public func next() -> (Loc, GridElement)? {
        currentLoc = Loc(row: currentLoc.row, col: currentLoc.col+1)

        if currentLoc.col >= grid.boundary.col {
           currentLoc = Loc(row: currentLoc.row+1, col: 0)
        }

        guard currentLoc.row < grid.boundary.row else { return nil }

        return (currentLoc, grid[currentLoc])
    }
}

public class Grid<Element>: GridProtocol {
    var storage: [Element]
    let rowSize: Int
    let rows: Int

    init(rows: [[Element]]) {
        self.storage = Array(rows.joined())
        self.rowSize = rows.first!.count
        self.rows = rows.count
    }

    public subscript (_ at: Loc) -> Element {
        get { storage[at.row * rowSize + at.col] }
        set { storage[at.row * rowSize + at.col] = newValue }
    }

    /// Boundary is past the valid edge of the grid, for use with `..<`
    public var boundary: Loc {
        Loc(row: rows, col: rowSize)
    }

    public func locInTopGrid(_ loc: Loc) -> Loc { loc }
}



public class SubGrid<Element>: GridProtocol {
    var parent: any GridProtocol<Element>
    let minRow, maxRow: Int
    let minCol, maxCol: Int

    /// Locations are inclusive
    init(inside parent: any GridProtocol<Element>, from: Loc, to: Loc) {
        self.parent = parent
        minRow = max(min(from.row, to.row), 0)
        minCol = max(min(from.col, to.col), 0)
        maxRow = min(max(from.row, to.row)+1, parent.boundary.row)
        maxCol = min(max(from.col, to.col)+1, parent.boundary.col)
    }

    public subscript (_ at: Loc) -> Element {
        get { parent[Loc(row: minRow+at.row, col: minCol+at.col)] }
        set { parent[Loc(row: minRow+at.row, col: minCol+at.col)] = newValue }
    }

    public var boundary: Loc { Loc(row: maxRow - minRow, col: maxCol - minCol) }

    public func locInTopGrid(_ loc: Loc) -> Loc {
        parent.locInTopGrid(Loc(row: minRow+loc.row, col: minCol+loc.col))
    }
}
