import { Answer, inputFromRegexLines, runDay } from "../lib.ts";

runDay(16, day, [{
  input: `Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II`,
  answer: [1651, 1707],
}]);

type Valve = {
  name: string;
  rate: number;
  tunnels: string[];
};
type ValveMap = Record<string, Valve>;

function day(input: string): Answer {
  const valves: ValveMap = Object.fromEntries(
    inputFromRegexLines(
      input,
      /Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? ([\w\s,]+)/,
      (m) => ({
        name: m[1],
        rate: parseInt(m[2]),
        tunnels: m[3].split(",").map((x) => x.trim()),
      }),
    ).map((v) => [v.name, v]),
  );

  const workingValves: string[] = Object.values(valves).filter((v) =>
    v.rate > 0
  ).map((v) => v.name);

  function findDistances(from: string): [string, number][] {
    const found: Record<string, number> = {};
    const toVisit: [string, number][] = [[from, 0]];
    while (toVisit.length > 0) {
      const [visit, dist] = toVisit.pop()!;
      if (found[from + visit] === undefined || found[from + visit] > dist) {
        found[from + visit] = dist;
        toVisit.push(
          ...valves[visit].tunnels.map((x): [string, number] => [x, dist + 1]),
        );
      }
    }
    return Object.entries(found);
  }

  const rates: Record<string, number> = Object.fromEntries(
    workingValves.map((v) => [v, valves[v].rate]),
  );
  const distances: Record<string, number> = Object.fromEntries(
    [...workingValves, "AA"].flatMap((v) => findDistances(v)),
  );

  const { route, pressure: partOne } = bestRoute("AA", workingValves, 30);
  console.log(route);

  function bestRoute(
    location: string,
    toOpen: string[],
    minutesLeft: number,
  ): { route: string; pressure: number } {
    if (minutesLeft <= 1) return { route: location, pressure: 0 };

    const best = toOpen.reduce(({ pressure, route }, next) => {
      const x = bestRoute(
        next,
        toOpen.filter((v) => v !== next),
        minutesLeft - 1 - distances[location + next],
      );
      return x.pressure > pressure ? x : { route, pressure };
    }, { pressure: 0, route: "" });

    const pressure = best.pressure + (rates[location] ?? 0) * minutesLeft;
    return { route: location + " " + best.route, pressure };
  }

  return partOne;
  const partTwo = 0;
  return [partOne, partTwo];
}
