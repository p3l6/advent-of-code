use core::fmt;
use dotenv;
use reqwest;
use std::fs;

pub struct Answer {
    pub part_one: Option<String>,
    pub part_two: Option<String>,
}

impl fmt::Display for Answer {
    fn fmt(&self, fmt: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            fmt,
            "| {} | {} |",
            self.part_one.as_ref().unwrap_or(&"<->".to_string()),
            self.part_two.as_ref().unwrap_or(&"<->".to_string())
        )
    }
}

impl PartialEq for Answer {
    fn eq(&self, other: &Self) -> bool {
        (self.part_one.is_none() || other.part_one.is_none() || self.part_one == other.part_one)
            && (self.part_two.is_none()
                || other.part_two.is_none()
                || self.part_two == other.part_two)
    }
}
pub fn input(day: u32) -> String {
    dotenv::dotenv().ok();
    let path = format!("inputs/input_{day}.txt");

    let contents = fs::read_to_string(&path).unwrap_or_else(|_| {
        println!("Fetching input");
        let token = dotenv::var("TOKEN").expect("Missing TOKEN in .env file.");
        let year = dotenv::var("YEAR").expect("Missing YEAR in .env file.");

        let client = reqwest::blocking::Client::new();
        let res = client
            .get(format!("https://adventofcode.com/{year}/day/{day}/input"))
            .header(reqwest::header::COOKIE, format!("session={token}"))
            .send()
            .unwrap()
            .text()
            .unwrap();

        let content = res;

        let _ = fs::create_dir("inputs");
        let _ = fs::write(path, &content);

        return content;
    });

    return contents;
}

pub fn input_as_i32_vec(input: String) -> Vec<i32> {
    input
        .lines()
        .filter(|&x| !x.is_empty())
        .map(|x| x.parse::<i32>().unwrap())
        .collect()
}

pub fn run_day(day_num: u32, day_fn: fn(String) -> Answer, tests: Vec<(&str, Answer)>) {
    let mut all = true;
    for (num, (test, answer)) in tests.iter().enumerate() {
        let actual = day_fn(test.to_string());
        if &actual != answer {
            all = false;
            println!("Case {}:", num);
            println!(" Expected {}", answer);
            println!(" But got  {}", actual);
        }
    }
    if all {
        println!("All tests passed.");
        println!("Result {} ", day_fn(input(day_num)));
    }
}
