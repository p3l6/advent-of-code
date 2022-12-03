extern crate aoc;
use std::collections::HashMap;

fn day(input: String) -> aoc::Answer {
    let score_table = HashMap::from([
        ("A X", 1 + 3), // r r
        ("A Y", 2 + 6), // r p
        ("A Z", 3 + 0), // r s
        ("B X", 1 + 0), // p r
        ("B Y", 2 + 3), // p p
        ("B Z", 3 + 6), // p s
        ("C X", 1 + 6), // s r
        ("C Y", 2 + 0), // s p
        ("C Z", 3 + 3), // s s
    ]);

    let scores = input.lines().map(|r| score_table[r.trim()]);

    let part_one = Some(scores.sum::<i32>().to_string());

    let score_table_two = HashMap::from([
        ("A X", 3 + 0), // r s
        ("A Y", 1 + 3), // r r
        ("A Z", 2 + 6), // r p

        ("B X", 1 + 0), // p r
        ("B Y", 2 + 3), // p p
        ("B Z", 3 + 6), // p s

        ("C X", 2 + 0), // s p
        ("C Y", 3 + 3), // s s
        ("C Z", 1 + 6), // s r
    ]);

    let scores_two = input.lines().map(|r| score_table_two[r.trim()]);

    let part_two = Some(scores_two.sum::<i32>().to_string());

    aoc::Answer { part_one, part_two }
}

fn main() {
    let tests = vec![(
        "A Y
B X
C Z",
        aoc::Answer {
            part_one: Some("15".to_string()),
            part_two: Some("12".to_string()),
        },
    )];

    aoc::run_day(2, day, tests);
}
