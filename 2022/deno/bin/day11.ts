import { Answer, runDay } from "../lib.ts";

runDay(11, day, [{
  input: `manual parsed test case`,
  answer: [10605, 2713310158],
}]);

interface Monkey {
  items: number[];
  inspect: (worry: number) => number;
  testDivisor: number;
  testTrueDest: number;
  testFalseDest: number;
  inspectionCount: number;
}

function monkeyBusiness(useTestCase: boolean, rounds: number, relief: boolean): number {
  const testCaseMonkeys: Monkey[] = [
    {
      items: [79, 98],
      inspect: (worry) => worry * 19,
      testDivisor: 23,
      testTrueDest: 2,
      testFalseDest: 3,
      inspectionCount: 0,
    },
    {
      items: [54, 65, 75, 74],
      inspect: (worry) => worry + 6,
      testDivisor: 19,
      testTrueDest: 2,
      testFalseDest: 0,
      inspectionCount: 0,
    },
    {
      items: [79, 60, 97],
      inspect: (worry) => worry * worry,
      testDivisor: 13,
      testTrueDest: 1,
      testFalseDest: 3,
      inspectionCount: 0,
    },
    {
      items: [74],
      inspect: (worry) => worry + 3,
      testDivisor: 17,
      testTrueDest: 0,
      testFalseDest: 1,
      inspectionCount: 0,
    },
  ];

  const actualMonkeys: Monkey[] = [
    {
      items: [89, 84, 88, 78, 70],
      inspect: (worry) => worry * 5,
      testDivisor: 7,
      testTrueDest: 6,
      testFalseDest: 7,
      inspectionCount: 0,
    },
    {
      items: [76, 62, 61, 54, 69, 60, 85],
      inspect: (worry) => worry + 1,
      testDivisor: 17,
      testTrueDest: 0,
      testFalseDest: 6,
      inspectionCount: 0,
    },
    {
      items: [83,89,53],
      inspect: (worry) => worry +8,
      testDivisor: 11,
      testTrueDest: 5,
      testFalseDest: 3,
      inspectionCount: 0,
    },
    {
      items: [95, 94, 85, 57],
      inspect: (worry) => worry + 4,
      testDivisor: 13,
      testTrueDest: 0,
      testFalseDest: 1,
      inspectionCount: 0,
    },
    {
      items: [82,98],
      inspect: (worry) => worry + 7,
      testDivisor: 19,
      testTrueDest: 5,
      testFalseDest: 2,
      inspectionCount: 0,
    },{
      items: [69],
      inspect: (worry) => worry + 2,
      testDivisor: 2,
      testTrueDest: 1,
      testFalseDest: 3,
      inspectionCount: 0,
    },
    {
      items: [82, 70, 58, 87, 59, 99, 92, 65],
      inspect: (worry) => worry * 11,
      testDivisor: 5,
      testTrueDest: 7,
      testFalseDest: 4,
      inspectionCount: 0,
    },
    {
      items: [91, 53, 96, 98, 68, 82],
      inspect: (worry) => worry * worry,
      testDivisor: 3,
      testTrueDest: 4,
      testFalseDest: 2,
      inspectionCount: 0,
    },
  ];

  const monkeys = useTestCase ? testCaseMonkeys : actualMonkeys;
  // we can divide by the product of all the tests, without changing any item's divisibility.
  const excessWorry = monkeys.reduce((t, m)=>t*m.testDivisor,1)

  for (let round = 0; round < rounds; round++) {
    for (const monkey of monkeys) {
      for (let item of monkey.items) {
        // inspect
        item = monkey.inspect(item);
        monkey.inspectionCount++;
        // relief
        if (relief) item = Math.floor(item / 3);
        // test worry level
        item = item % excessWorry;
        const dest = item % monkey.testDivisor === 0
          ? monkey.testTrueDest
          : monkey.testFalseDest;
        // throw item
        monkeys[dest].items.push(item);
      }
      monkey.items = [];
    }
  }

  const inspectCounts = monkeys.map((m) => m.inspectionCount).sort((a, b) => b - a)
  return inspectCounts[0] * inspectCounts[1]
}

function day(input: string): Answer {
  const partOne = monkeyBusiness( input === "manual parsed test case" , 20, true);
  const partTwo = monkeyBusiness( input === "manual parsed test case" , 10000, false);
  return [partOne, partTwo];
}
