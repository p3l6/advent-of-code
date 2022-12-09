import { Answer, inputFromRegexLines, runDay } from "../lib.ts";

runDay(9, day, [{
  input: `R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2`,
  answer: 13,
}]);

interface Point {
  x: number
  y: number
}

//  Y U P
//  L   R
//  G D W
type Dir = 'U'|'D'| 'L' | 'R' | 'Y' | 'P' | 'G' | 'W'
type Path = Dir[]

function move(p:Point, dir:Dir, by = 1): Point {
  switch (dir) {
    case 'Y': return {x:p.x-by, y:p.y+by}
    case 'U': return {x:p.x,    y:p.y+by}
    case 'P': return {x:p.x+by, y:p.y+by}
    case 'L': return {x:p.x-by, y:p.y}
    case 'R': return {x:p.x+by, y:p.y}
    case 'G': return {x:p.x-by, y:p.y-by}
    case 'D': return {x:p.x,    y:p.y-by}
    case 'W': return {x:p.x+by, y:p.y-by}
  }
}

function tailPath(headPath: Path): Path {
  // Setup a map: Given a tail orientation and head movement, what happens to the tail?
  type TailState = {tailMoved: Dir | undefined, newTailDir: Dir | undefined}
  type Translation = Partial<Record<Dir, TailState>>
  const moveMap: Partial<Record<Dir, Translation>> = {
    // Initial setup for one edge and one corner
    'Y': {'Y': {tailMoved:'Y', newTailDir:'Y'},       'U': {tailMoved:'Y', newTailDir:'U'},             'P': {tailMoved:'U', newTailDir:'U'},
          'L': {tailMoved:'Y', newTailDir:'L'},                                                         'R': {tailMoved:undefined, newTailDir:'U'},
          'G': {tailMoved:'L', newTailDir:'L'},       'D': {tailMoved:undefined, newTailDir:'L'},       'W': {tailMoved:undefined, newTailDir:undefined}},
    'U': {'Y': {tailMoved:'Y', newTailDir:'U'},       'U': {tailMoved:'U', newTailDir:'U'},             'P': {tailMoved:'P', newTailDir:'U'},
          'L': {tailMoved:undefined, newTailDir:'Y'},                                                   'R': {tailMoved:undefined, newTailDir:'P'},
          'G': {tailMoved:undefined, newTailDir:'L'}, 'D': {tailMoved:undefined, newTailDir:undefined}, 'W': {tailMoved:undefined, newTailDir:'R'},}
  }

  const rDir = (d:Dir|undefined):Dir|undefined => (d===undefined?undefined:({'Y':'P','U':'R','P':'W','R':'D','W':'G','D':'L','G':'Y','L':'U'} as Record<Dir,Dir>)[d])
  const rotate = (m:Translation):Translation => Object.fromEntries(Object.entries(m).map(([k,{tailMoved,newTailDir}])=>[rDir(k as Dir), {tailMoved:rDir(tailMoved), newTailDir:rDir(newTailDir)}]))

  // rotate to caculate rest of the translations
  moveMap['P'] = rotate(moveMap['Y']!);
  moveMap['W'] = rotate(moveMap['P']!);
  moveMap['G'] = rotate(moveMap['W']!);
  moveMap['R'] = rotate(moveMap['U']!);
  moveMap['D'] = rotate(moveMap['R']!);
  moveMap['L'] = rotate(moveMap['D']!);



  let tailDir: Dir | undefined = undefined; // dir from tail -> head. undefined if they occupy the same location
  const tailPath: Path = [];

  for (const d of headPath) {
    if (tailDir === undefined) {
      tailDir = d
    } else {
      const {tailMoved, newTailDir} = (moveMap[tailDir]![d]! as TailState);
      tailDir = newTailDir;
      if (tailMoved) tailPath.push(tailMoved);
    }
  }
  return tailPath
}

function pathVisits(path: Path): number {
  // unique squares a path visits
  let p = {x:0,y:0};
  const visited = new Set([`${p.x},${p.y}`]);
  for (const d of path) {
    p = move(p, d)
    visited.add(`${p.x},${p.y}`)
  }
  return visited.size
}

function day(input: string): Answer {
  const path: Path = inputFromRegexLines(
    input,
    /([UDLR]) (\d+)/,
    (m):Path => (Array.from({length:parseInt(m[2])}, ()=>(m[1] as Dir))),
  ).flat();

  let tail = tailPath(path);
  const partOne = pathVisits(tail);

  // we've done one knot, calculate the next 8 knots to get the tail of a ten-knot rope
  for (let i = 0; i < 8; i++) tail = tailPath(tail);

  const partTwo = pathVisits(tail);
  return [partOne, partTwo];
}
