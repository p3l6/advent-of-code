import { config } from "https://deno.land/x/dotenv@v3.2.0/mod.ts";
import { ensureDir } from "https://deno.land/std@0.167.0/fs/mod.ts";

type AnswerPart = string | number;
type FullAnswer = [AnswerPart, AnswerPart];
export type Answer = AnswerPart | FullAnswer;

export interface TestCase {
  input: string;
  answer: Answer;
}

async function fetchInput(num: number): Promise<string> {
  const env = config(); // Load YEAR and TOKEN from a .env file
  const path = `inputs/input_${num}.txt`;
  try {
    const contents = Deno.readTextFileSync(path);
    return contents;
  } catch (_error) {
    console.log("Fetching input");
    console.log(`https://adventofcode.com/${env.YEAR}/day/${num}/input`);
    const response = await fetch(
      `https://adventofcode.com/${env.YEAR}/day/${num}/input`,
      {
        method: "GET",
        headers: {
          "cookie": `session=${env.TOKEN}`,
          "User-Agent": "github.com/pwxn/AdventOfCode via typescript & fetch",
        },
      },
    );
    const contents = await response.text();
    const encoder = new TextEncoder();
    ensureDir("inputs");
    Deno.writeFileSync(path, encoder.encode(contents));
    return contents;
  }
}

function fmt(answer: Answer): string {
  if (answer instanceof Array) {
    return `| ${answer[0]} | ${answer[1]} |`;
  }
  return `| ${answer} | <-?-> |`;
}

function cmp(a: Answer, b: Answer): boolean {
  // if one only has a single part, only consider that part
  if (a instanceof Array) {
    if (b instanceof Array) return a[0] === b[0] && a[1] === b[1];
    else return a[0] === b;
  } else {
    if (b instanceof Array) return a === b[0];
    else return a === b;
  }
}

export async function runDay(
  num: number,
  day: (input: string) => Answer,
  testCases: TestCase[],
) {
  let all = true;
  for (const [i, tc] of testCases.entries()) {
    const result = day(tc.input);
    if (!cmp(tc.answer, result)) {
      all = false;
      console.log(
        `Text Case ${i}:\n Expected ${fmt(tc.answer)}\n But Got  ${
          fmt(result)
        }`,
      );
    }
  }
  if (all) {
    console.log("All tests passed.");
    console.log(`Result: ${fmt(day(await fetchInput(num)))}`);
  }
}

export function notEmpty<TValue>(
  value: TValue | null | undefined,
): value is TValue {
  return value !== null && value !== undefined;
}

export function inputFromRegexLines<Item>(
  input: string,
  regex: RegExp,
  convert: (m: RegExpMatchArray) => Item,
): Item[] {
  return input
    .split("\n")
    .filter((x) => x.length > 0)
    .map((ln) => {
      const match = ln.match(regex);
      if (match !== null && match !== undefined) return match;
      console.log(`Input line did not match regex! ${ln}`);
      return undefined;
    })
    .filter(notEmpty)
    .map(convert);
}

export function inputFromLines(input: string): string[] {
  return input
    .split("\n")
    .filter((x) => x.length > 0);
}

export function inputAsIntGrid(input: string): number[][] {
  return input
    .split("\n")
    .filter((x) => x.length > 0)
    .map((line) => Array.from(line).map((x) => parseInt(x)));
}

export function inputAsCharGrid(input: string): string[][] {
  return input
    .split("\n")
    .filter((x) => x.length > 0)
    .map((line) => Array.from(line));
}

export function emptyGrid<T>(
  value: T,
  rows: number,
  cols: number | undefined = undefined,
): T[][] {
  return Array.from(
    { length: rows },
    () => Array.from({ length: cols ?? rows }, () => value),
  );
}
