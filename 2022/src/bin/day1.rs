extern crate aoc;

fn day(input: String) -> aoc::Answer {
    let elfs: Vec<String> = input.split("\n\n").map(str::to_string).collect();
    let mut cals = elfs
        .iter()
        .map(|elf_input| aoc::input_as_i32_vec(elf_input.to_string()).iter().sum())
        .collect::<Vec<i32>>();

    cals.sort();
    cals.reverse();

    let part_one = Some(cals[0].to_string());
    let part_two = Some((cals[0] + cals[1] + cals[2]).to_string());

    aoc::Answer { part_one, part_two }
}

fn main() {
    let tests = vec![(
        "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000",
        aoc::Answer {
            part_one: Some("24000".to_string()),
            part_two: Some("45000".to_string()),
        },
    )];

    aoc::run_day(1, day, tests);
}
