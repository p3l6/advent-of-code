import { Answer, emptyGrid, inputFromLines, runDay } from "../lib.ts";

runDay(14, day, [{
  input: `498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9`,
  answer: [24, 93],
}]);

interface Point {
  depth: number
  horiz: number
}

function range(size:number, startAt = 0):ReadonlyArray<number> {
  return [...Array(size).keys()].map(i => i + startAt);
}

function pointsFromInputLine(line: string): Point[] {
  const corners: Point[] = line.split(" -> ").map(c=>{const [horiz,depth] = c.split(","); return {horiz:parseInt(horiz), depth:parseInt(depth)}});
  const allPoints: Point[] = [...corners]
  for (let i = 0; i < corners.length-1; i++) {
    if (corners[i].depth === corners[i+1].depth) {
      const startAt=Math.min(corners[i+1].horiz,corners[i].horiz);
      const size=Math.abs(corners[i+1].horiz-corners[i].horiz);
      allPoints.push(...range(size, startAt).map(h=>({depth:corners[i].depth, horiz:h })))
    } else {
      const startAt=Math.min(corners[i+1].depth,corners[i].depth);
      const size=Math.abs(corners[i+1].depth-corners[i].depth);
      allPoints.push(...range(size, startAt).map(d=>({depth:d, horiz:corners[i].horiz })))
    }
  }
  return allPoints
}

function day(input: string): Answer {
  const lines = inputFromLines(input);
  const points = lines.flatMap(pointsFromInputLine);
  const lowestRockLevel = points.reduce((max:number, p)=>Math.max(p.depth,max),0);
  const sandStart = 500;
  const grid = emptyGrid('.', lowestRockLevel+2, 1000);
  points.forEach(p=>grid[p.depth][p.horiz] = '#')

  let partOne = 0;
  let partTwo = 0;
  let partOneOver = false;
  let sand:Point = {horiz: sandStart, depth: 0};

  while (grid[0][sandStart] !== 'o'){
    sand = {horiz: sandStart, depth: 0};
    while (sand.depth < lowestRockLevel+1) {
      if (grid[sand.depth+1][sand.horiz] === ".") {
        sand.depth++;
      } else if (grid[sand.depth+1][sand.horiz-1] === ".") {
        sand.depth++;
        sand.horiz--;
      } else if (grid[sand.depth+1][sand.horiz+1] === ".") {
        sand.depth++;
        sand.horiz++;
      } else {
        break;
      }
    }

    grid[sand.depth][sand.horiz] = 'o';
    if (!partOneOver) {
      if (sand.depth > lowestRockLevel) partOneOver = true;
      else partOne++;
    }
    partTwo++;
  }
  // console.log(grid.map(l=>l.join("")).join("\n"))
  return [partOne, partTwo];
}
