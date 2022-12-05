import { Answer, inputFromRegexLines, notEmpty, runDay } from "../lib.ts";

runDay(5, day, [{
  input: `
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
`,
  answer: ["CMZ", "MCD"],
}]);

interface Step {
  count: number;
  src: number;
  dest: number;
}

function day(input: string): Answer {
  const [inputStacks, inputSteps] = input.split("\n\n");

  const steps = inputFromRegexLines(
    inputSteps,
    /move (\d+) from (\d+) to (\d+)/,
    (m) => ({
      count: parseInt(m[1]),
      src: parseInt(m[2]),
      dest: parseInt(m[3]),
    } as Step),
  );

  const inputStackRows = inputStacks.split("\n");
  const numStacks = inputStackRows.pop()!.split(" ").filter(notEmpty)
    .filter((s) => s.length > 0).map((x) => parseInt(x)).length;
  const stacks: Array<Array<string>> = Array.from(
    { length: numStacks },
    () => [],
  );
  for (const row of inputStackRows.reverse()) {
    for (let s = 0; s < numStacks; s++) {
      const char = row.at(4 * s + 1);
      if (char !== undefined && char !== " ") stacks[s].push(char);
    }
  }

  const stacks2: Array<Array<string>> = JSON.parse(JSON.stringify((stacks))); // deep copy

  for (const s of steps) {
    for (let i = 0; i < s.count; i++) {
      const item = stacks[s.src - 1].pop()!;
      stacks[s.dest - 1].push(item);
    }
  }

  for (const s of steps) {
    const tmp = [];
    for (let i = 0; i < s.count; i++) {
      const item = stacks2[s.src - 1].pop()!;
      tmp.push(item)
    }
    while (tmp.length > 0) {
      const item = tmp.pop()!
      stacks2[s.dest - 1].push(item);
    }
  }

  const partOne = stacks.map((s) => s.pop()).join("");
  const part2 = stacks2.map((s) => s.pop()).join("");
  return [partOne, part2];
}
