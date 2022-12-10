import { Answer, inputFromLines, runDay } from "../lib.ts";

runDay(10, day, [{
  input: `addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop`,
  answer: 13140,
}]);

function day(input: string): Answer {
  const lines = inputFromLines(input);

  let x = 1;
  const cycles: number[] = [0, x];
  for (const line of lines) {
    if (line === "noop") {
      cycles.push(x);
    } else if (line.startsWith("addx")) {
      const value = parseInt(line.slice(4));
      cycles.push(x);
      x += value;
      cycles.push(x);
    } else {
      console.log(`Unexpected Line: ${line}`);
    }
  }

  const partOne = [20, 60, 100, 140, 180, 220].reduce(
    (t, i) => (t + (i * cycles[i])),
    0,
  );

  const screen = cycles.map((spritePosition, cycle) =>
    Math.abs(spritePosition - (cycle - 1) % 40) < 2 ? "#" : "_"
  ).join("");
  [1, 41, 81, 121, 161, 201].forEach((x) =>
    console.log(screen.slice(x, x + 39))
  );

  return partOne;
}
