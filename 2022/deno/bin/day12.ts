import { Answer, inputAsCharGrid, runDay } from "../lib.ts";

runDay(12, day, [{
  input: `Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi`,
  answer: [31, 29],
}]);

interface Point {
  row: number
  col: number
}

interface Path {
  at: Point
  route: string
}

function optionsFrom(start:Path, grid: string[][], ingoring:Set<string>, ascending = true): Path[] {
  // ingored format: `${Point.row},${Point.col}`
  const options: Path[] = [
    {at: {row:start.at.row+1, col:start.at.col}, route: start.route + 'v'},
    {at: {row:start.at.row-1, col:start.at.col}, route: start.route + '^'},
    {at: {row:start.at.row, col:start.at.col+1}, route: start.route + '>'},
    {at: {row:start.at.row, col:start.at.col-1}, route: start.route + '<'}
  ]
  return options.filter(opt=> {
    if (!(opt.at.row >= 0 && opt.at.row < grid.length && opt.at.col >= 0 && opt.at.col < grid[0].length)) return false
    if (ingoring.has(`${opt.at.row},${opt.at.col}`)) return false;

    const startChar = grid[start.at.row][start.at.col]
    const optChar = grid[opt.at.row][opt.at.col]
    if (ascending) return (startChar === 'S' ? 'a' : startChar).charCodeAt(0) +1 >= (optChar === 'E' ? 'z' : optChar).charCodeAt(0)
    else return (startChar === 'E' ? 'z' : startChar).charCodeAt(0) <= (optChar === 'S' ? 'a' : optChar).charCodeAt(0) + 1
  })
}

function printPath(path: Path, grid:string[][], startRow:number, startCol:number) {
  const output: string[][] = structuredClone(grid);

  let p = {row:startRow, col:startCol}
  for (const r of path.route) {
    output[p.row][p.col] = r
    switch (r) {
      case 'v': p = {row:p.row+1, col:p.col}; break;
      case '^': p = {row:p.row-1, col:p.col}; break;
      case '<': p = {row:p.row, col:p.col-1}; break;
      case '>': p = {row:p.row, col:p.col+1}; break;
      default: console.log(`unexpected route char: ${r}`); break;
    }
  }

  console.log(output.map(x=>x.join("")).join("\n"))
}


function day(input: string): Answer {
  const grid = inputAsCharGrid(input);

  let startRow = grid.findIndex((r)=>r.includes('S'))
  let startCol = grid[startRow].findIndex((c)=>c==='S')
  let paths: Path[] = [{at:{row: startRow, col:startCol}, route: ""}];
  let partOne = 0;
  const visitedSquares: Set<string> = new Set()

  while(paths.length > 0) {
    const path = paths.shift()!;
    const at = path.at;
    if (grid[at.row][at.col] === 'E') {
      partOne = path.route.length;
      printPath(path, grid, startRow, startCol);
      break;
    }
    const newOptions = optionsFrom(path, grid, visitedSquares)
    newOptions.forEach(x=>visitedSquares.add(`${x.at.row},${x.at.col}`))
    paths.push(...newOptions)
  }

  // repeat the exact thing, but starting at 'E', ending at 'a'
  startRow = grid.findIndex((r)=>r.includes('E'))
  startCol = grid[startRow].findIndex((c)=>c==='E')
  paths = [{at:{row: startRow, col:startCol}, route: ""}];
  visitedSquares.clear()
  let partTwo = 0;
  while(paths.length > 0) {
    const path = paths.shift()!;
    const at = path.at;
    if (grid[at.row][at.col] === 'a') {
      partTwo = path.route.length;
      printPath(path, grid, startRow, startCol);
      break;
    }
    const newOptions = optionsFrom(path, grid, visitedSquares, false)
    newOptions.forEach(x=>visitedSquares.add(`${x.at.row},${x.at.col}`))
    paths.push(...newOptions)
  }
  return [partOne, partTwo];
}
