import { Answer, inputFromRegexLines, runDay } from "../lib.ts";

runDay(15, day, [{
  input: `test case
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3`,
  answer: [26, 56000011],
}]);

interface Sensor {
  sx: number;
  sy: number;
  bx: number;
  by: number;
  d: number;
}

function isCovered(
  x: number,
  y: number,
  sensors: Sensor[],
): "beacon" | "possible" | "covered" {
  let covered = false;
  let beacon = false;
  for (const s of sensors) {
    if (!covered && Math.abs(s.sx - x) + Math.abs(s.sy - y) <= s.d) {
      covered = true;
    }
    if (s.bx === x && s.by === y) {
      beacon = true;
      break;
    }
  }
  if (beacon) return "beacon";
  if (covered) return "covered";
  return "possible";
}

function day(input: string): Answer {
  const sensors = inputFromRegexLines(
    input,
    /Sensor at x=([-\d]+), y=([-\d]+): closest beacon is at x=([-\d]+), y=([-\d]+)/,
    (m) => {
      const sx = parseInt(m[1]);
      const sy = parseInt(m[2]);
      const bx = parseInt(m[3]);
      const by = parseInt(m[4]);
      return { sx, sy, bx, by, d: Math.abs(sx - bx) + Math.abs(sy - by) };
    },
  );
  const bounds = sensors.reduce((b, s) => ({
    xMin: Math.min(b.xMin, s.sx - s.d),
    xMax: Math.max(b.xMax, s.sx + s.d),
    yMin: Math.min(b.yMin, s.sy - s.d),
    yMax: Math.max(b.yMax, s.sy + s.d),
  }), {
    xMin: sensors[0].sx,
    xMax: sensors[0].sx,
    yMin: sensors[0].sy,
    yMax: sensors[0].sy,
  });

  const checkY = input.startsWith("test case") ? 10 : 2000000;
  const coveredPoints = new Set<number>();
  for (let x = bounds.xMin; x <= bounds.xMax; x++) {
    if (isCovered(x, checkY, sensors) === "covered") coveredPoints.add(x);
  }

  const partOne = coveredPoints.size;

  let partTwo = 0;
  const scanMax = input.startsWith("test case") ? 20 : 4000000;
  const verify = (x: number, y: number) => {
    if (
      0 <= x && x <= scanMax && 0 <= y && y <= scanMax &&
      isCovered(x, y, sensors) === "possible"
    ) {
      partTwo = x * 4000000 + y;
    }
  };

  // check all points just outside each sensor's radius
  for (const s of sensors) {
    verify(s.sx - s.d - 1, s.sy)
    verify(s.sx + s.d + 1, s.sy)

    for (let xOff = -s.d; xOff <= s.d; xOff++) {
      verify(s.sx + xOff, s.sy + (1 + s.d - Math.abs(xOff)))
      verify(s.sx + xOff, s.sy - (1 + s.d - Math.abs(xOff)))
      if (partTwo !== 0) break;
    }
    if (partTwo !== 0) break;
  }

  return [partOne, partTwo];
}
