import { Answer, inputFromRegexLines, inputFromLines, runDay } from "../lib.ts";

runDay(18, day, [{
  input: `2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5`,
  answer: [64, 58],
}]);

function day(input: string): Answer {
  const cubeSet = new Set(inputFromLines(input))
  const cubes = inputFromRegexLines(input,/(\d+),(\d+),(\d+)/,(m)=>({xyz:m[0], x:parseInt(m[1]),y:parseInt(m[2]),z:parseInt(m[3])}))

  const partOne = cubes.reduce((area, c)=>{
    let sides = 0
    if (!cubeSet.has(`${c.x+1},${c.y},${c.z}`)) sides ++;
    if (!cubeSet.has(`${c.x-1},${c.y},${c.z}`)) sides ++;
    if (!cubeSet.has(`${c.x},${c.y+1},${c.z}`)) sides ++;
    if (!cubeSet.has(`${c.x},${c.y-1},${c.z}`)) sides ++;
    if (!cubeSet.has(`${c.x},${c.y},${c.z+1}`)) sides ++;
    if (!cubeSet.has(`${c.x},${c.y},${c.z-1}`)) sides ++;

    return area + sides
  }, 0)

  const min = cubes.reduce((min,c)=>({x:Math.min(min.x,c.x-1),y:Math.min(min.y,c.y-1),z:Math.min(min.z,c.z-1)}),{x:cubes[0].x, y:cubes[0].y, z:cubes[0].z})
  const max = cubes.reduce((max,c)=>({x:Math.max(max.x,c.x+1),y:Math.max(max.y,c.y+1),z:Math.max(max.z,c.z+1)}),{x:cubes[0].x, y:cubes[0].y, z:cubes[0].z})
  const airSet = new Set<string>()
  const airToCheck = [min]
  let partTwo = 0;
  while(airToCheck.length > 0) {
    const air = airToCheck.pop()!

    const visit = (next:typeof min) => {
      const hashKey = `${next.x},${next.y},${next.z}`
      if (cubeSet.has(hashKey)) partTwo ++;
      else {
        if (!airSet.has(hashKey) && min.x <= next.x && next.x <= max.x && min.y <= next.y && next.y <= max.y && min.z <= next.z && next.z <= max.z) airToCheck.push(next)
        airSet.add(hashKey)
      }
    }

    visit({...air, x:air.x+1})
    visit({...air, x:air.x-1})
    visit({...air, y:air.y+1})
    visit({...air, y:air.y-1})
    visit({...air, z:air.z+1})
    visit({...air, z:air.z-1})

  }

  return [partOne, partTwo];
}
