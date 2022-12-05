extern crate aoc;

fn str_mask(ruck: &str) -> u64 {
    ruck.chars()
        .fold(0, |mask, item| mask | 1 << item_priority(item))
}

fn mask_priority(mask: u64) -> i32 {
    let mut m = mask;
    let mut priority = 0;
    while m & 1 == 0 {
        m = m >> 1;
        priority += 1;
    }
    priority
}

fn shared_item_priority(ruck: &str) -> i32 {
    mask_priority(str_mask(&ruck[..ruck.len() / 2]) & str_mask(&ruck[ruck.len() / 2..]))
}

fn shared_item_group(a: &str, b: &str, c: &str) -> i32 {
    mask_priority(str_mask(a) & str_mask(b) & str_mask(c))
}

fn item_priority(item: char) -> i32 {
    let ascii = item as i32;
    if ascii < 91 {
        return ascii - 38;
    } else {
        return ascii - 96;
    }
}

fn day(input: String) -> aoc::Answer {
    let part_one = Some(
        input
            .lines()
            .map(shared_item_priority)
            .sum::<i32>()
            .to_string(),
    );

    let part_two = Some(
        input
            .lines()
            .collect::<Vec<&str>>()
            .chunks(3)
            .map(|chunk| shared_item_group(chunk[0], chunk[1], chunk[2]))
            .sum::<i32>()
            .to_string(),
    );
    aoc::Answer { part_one, part_two }
}

fn main() {
    let tests = vec![(
        "vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw",
        aoc::Answer {
            part_one: Some("157".to_string()),
            part_two: Some("70".to_string()),
        },
    )];

    aoc::run_day(3, day, tests);
}
