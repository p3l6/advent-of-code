import { Answer, emptyGrid, inputAsIntGrid, runDay } from "../lib.ts";

runDay(8, day, [{
  input: `30373
25512
65332
33549
35390`,
  answer: [21, 8],
}]);

function day(input: string): Answer {
  const grid = inputAsIntGrid(input);
  const visibleTrees = emptyGrid(false, grid.length, grid[0].length);
  const rows = grid.length;
  const cols = grid[0].length;

  visibleTrees[0][0] = true;
  visibleTrees[0][cols-1] = true;
  visibleTrees[rows-1][0] = true;
  visibleTrees[rows-1][cols-1] = true;

  for (let row = 1; row < grid.length - 1; row++) {
    visibleTrees[row][0] = true;
    visibleTrees[row][cols-1] = true;

    let max = grid[row][0];
    for (let col = 1; col < cols - 1; col++) if (max < grid[row][col]) {max = grid[row][col]; visibleTrees[row][col] = true;}
    max = grid[row][cols-1];
    for (let col = cols-2; col >= 1; col--)  if (max < grid[row][col]) {max = grid[row][col]; visibleTrees[row][col] = true;}
  }

  for (let col = 1; col < grid[0].length - 1; col++) {
    visibleTrees[0][col] = true;
    visibleTrees[rows-1][col] = true;

    let max = grid[0][col];
    for (let row = 1; row < rows - 1; row++) if (max < grid[row][col]) {max = grid[row][col]; visibleTrees[row][col] = true;}
    max = grid[rows-1][col];
    for (let row = rows-2; row >= 1; row--)  if (max < grid[row][col]) {max = grid[row][col]; visibleTrees[row][col] = true;}
  }

  const partOne = visibleTrees.flat().reduce((t,x)=>x?t+1:t, 0); // sum()

  const scenicScores = emptyGrid(0, grid.length, grid[0].length);
  for (let row = 1; row < grid.length - 1; row++) {
    for (let col = 1; col < grid[0].length - 1; col++) {
      let visRight = 1; while (col+visRight+1 < cols && grid[row][col] > grid[row][col+visRight]) visRight++;
      let visLeft  = 1; while (col-visLeft-1  >= 0   && grid[row][col] > grid[row][col-visLeft])  visLeft++;
      let visUp    = 1; while (row-visUp-1    >= 0   && grid[row][col] > grid[row-visUp][col])    visUp++;
      let visDown  = 1; while (row+visDown+1  < rows && grid[row][col] > grid[row+visDown][col])  visDown++;
      scenicScores[row][col] = visRight * visLeft * visUp * visDown;
    }
  }

  const partTwo = scenicScores.flat().reduce((a,b)=>a>b?a:b, 0); // max()
  return [partOne, partTwo];
}
