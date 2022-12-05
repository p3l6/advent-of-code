package main

import ("fmt"
"strings"
"strconv")

func main() {

  input := `2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8`

  pairs := strings.Split(input, "\n")
  countContained := 0
  countOverlap := 0

  for _, pair := range pairs {
    sections := strings.Split(pair, ",")
    aStart,_ := strconv.Atoi(strings.Split(sections[0], "-")[0])
    aEnd  ,_ := strconv.Atoi(strings.Split(sections[0], "-")[1])
    bStart,_ := strconv.Atoi(strings.Split(sections[1],"-")[0])
    bEnd  ,_ := strconv.Atoi(strings.Split(sections[1], "-")[1])
    // fmt.Println(aStart, aEnd, bStart, bEnd)
    if (aStart <= bStart && bEnd <= aEnd) ||
       (bStart <= aStart && aEnd <= bEnd) {
      countContained++
      countOverlap++
      // fmt.Println(pair, "|", aStart, bStart, bEnd, aEnd, "|", bStart, aStart, aEnd, bEnd,)
    } else if (aStart <= bStart && bStart <= aEnd && aEnd <= bEnd) ||
              (bStart <= aStart && aStart <= bEnd && bEnd <= aEnd) {
      countOverlap++
      // fmt.Println(pair, "|", aStart, bStart, bEnd, aEnd, "|", bStart, aStart, aEnd, bEnd,)
    }
  }
  fmt.Println(countContained)
  fmt.Println(countOverlap)
}
