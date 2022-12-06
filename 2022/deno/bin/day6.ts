import { Answer, runDay } from "../lib.ts";

runDay(6, day, [{
  input: `mjqjpqmgbljsphdztnvjfqwrcgsmlb`,
  answer: 7,
}, {
  input: `bvwbjplbgvbhsrlpgdmjqwftvncz`,
  answer: 5,
}, {
  input: `nppdvjthqldpwncqszvftbrmjlhg`,
  answer: 6,
}, {
  input: `nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg`,
  answer: 10,
}, {
  input: `zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw`,
  answer: 11,
}]);

function hasDuplicateChars(str: string): boolean {
  return (new Set(str)).size !== str.length;
}

function day(input: string): Answer {
  let partOne = -1;
  for (let i = 4; i <= input.length; i++) {
    if (!hasDuplicateChars(input.slice(i - 4, i))) {
      partOne = i;
      break;
    }
  }

  let partTwo = 0;
  for (let i = 14; i <= input.length; i++) {
    if (!hasDuplicateChars(input.slice(i - 14, i))) {
      partTwo = i;
      break;
    }
  }
  return [partOne, partTwo];
}
