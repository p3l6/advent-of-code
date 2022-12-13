import { Answer, runDay } from "../lib.ts";

runDay(13, day, [{
  input: `[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]`,
  answer: [13, 140],
}]);

type NumOrArr = number | NumOrArr[];

function properlyOrdered(a: NumOrArr, b: NumOrArr): number {
  if (a instanceof Array) {
    if (b instanceof Array) {
      for (let i = 0; i < Math.min(a.length, b.length); i++) {
        const x = properlyOrdered(a[i], b[i]);
        if (x !== 0) return x;
      }
      if (a.length !== b.length) {
        return a.length < b.length ? -1 : 1;
      }
      return 0;
    } else return properlyOrdered(a, [b]);
  } else {
    if (b instanceof Array) {
      return properlyOrdered([a], b);
    } else return a - b;
  }
}

function day(input: string): Answer {
  const pairs: [NumOrArr, NumOrArr][] = input
    .split("\n\n")
    .map((p) =>
      p
        .split("\n")
        .filter((x) => x.length > 0)
        .map((l) => JSON.parse(l))
    ) as [NumOrArr, NumOrArr][];

  const orderings = pairs.map(([a, b]) => properlyOrdered(a, b));
  console.log(orderings);

  const partOne = orderings.reduce(
    (t, order, i) => order <= -1 ? t + i + 1 : t,
    0,
  );

  const packets = pairs.flat();
  const divider1 = 1 +
    packets.reduce(
      (t: number, packet) => properlyOrdered(packet, [[2]]) <= -1 ? t + 1 : t,
      0,
    );
  const divider2 = 2 +
    packets.reduce(
      (t: number, packet) => properlyOrdered(packet, [[6]]) <= -1 ? t + 1 : t,
      0,
    );
  const partTwo = divider1 * divider2;

  return [partOne, partTwo];
}
