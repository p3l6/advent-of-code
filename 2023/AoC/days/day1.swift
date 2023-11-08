import Shared

@main @dayMain struct DayRunner: Runnable {
    let dayNumber = 1
    let tests = [
        TestCase("", .one(6))
    ]
}

func day(_ input: String) -> Answer {
    let lines = input

    return .one(5) //  + .two(7)
}
