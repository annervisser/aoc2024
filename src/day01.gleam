import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(lines) = simplifile.read(from: "./src/day01.input.txt")

  let #(list1, list2) =
    string.trim(lines)
    |> string.split(on: "\n")
    |> list.filter_map(with: string.split_once(_, on: "   "))
    |> list.unzip
    |> map_pair(with: parse_list)

  let distance = list.map2(list1, list2, with: int_diff) |> int.sum

  io.println("Distance (part 1): " <> int.to_string(distance))

  let list2itemcount =
    list.group(list2, fn(a) { a })
    |> dict.map_values(with: fn(_k, v) { list.length(v) })

  let similarity =
    list.map(list1, fn(a) {
      a
      * case dict.get(list2itemcount, a) {
        Error(Nil) -> 0
        Ok(count) -> count
      }
    })
    |> int.sum

  io.println("Similarity (part 2): " <> int.to_string(similarity))
}

fn int_diff(a: Int, b: Int) -> Int {
  int.absolute_value(int.subtract(a, b))
}

fn parse_list(items: List(String)) -> List(Int) {
  list.filter_map(items, int.parse)
  |> list.sort(by: int.compare)
}

fn map_pair(pair: #(a, a), with fun: fn(a) -> b) -> #(b, b) {
  let #(a, b) = pair
  #(fun(a), fun(b))
}
