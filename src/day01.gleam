import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(lines) = simplifile.read(from: "./src/day01.input.txt")

  let distance =
    string.trim(lines)
    |> string.split(on: "\n")
    |> list.filter_map(with: string.split_once(_, on: "   "))
    |> list.unzip
    |> map_pair(with: parse_list)
    |> pair_map2(with: int_diff)
    |> int.sum

  io.println("Distance: " <> int.to_string(distance))
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

fn pair_map2(pair: #(List(a), List(b)), with fun: fn(a, b) -> c) -> List(c) {
  let #(a, b) = pair
  list.map2(a, b, with: fun)
}
