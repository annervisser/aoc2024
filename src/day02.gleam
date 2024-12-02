import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(lines) = simplifile.read(from: "./src/day02.sample.txt")

  let floors =
    string.trim(lines)
    |> string.split(on: "\n")
    |> list.map(with: parse_line)

  let result =
    floors
    |> list.map(with: fn(floor) {
      case floor {
        [] -> #(0, Unsafe)
        [first, ..rest] -> list.fold_until(rest, #(first, Unknown), with: state)
      }
    })
    |> list.count(where: fn(r) { is_safe(r.1) })
  io.println("Safe levels: " <> int.to_string(result))
}

fn parse_line(line: String) {
  line
  |> string.split(on: " ")
  |> list.filter_map(with: int.parse)
}

pub type Direction {
  Inc
  Dec
}

pub type State {
  Safe(Direction)
  Unknown
  Unsafe
}

fn state(acc: #(Int, State), cur: Int) -> list.ContinueOrStop(#(Int, State)) {
  let #(prev, dir) = acc
  case dir, direction(prev, cur) {
    Unknown, newdir -> list.Continue(#(cur, newdir))
    Safe(Inc), Safe(Inc) -> list.Continue(#(cur, Safe(Inc)))
    Safe(Dec), Safe(Dec) -> list.Continue(#(cur, Safe(Dec)))
    _, _ -> list.Stop(#(cur, Unsafe))
  }
}

fn direction(prev: Int, cur: Int) -> State {
  case cur - prev {
    d if d >= 1 && d <= 3 -> Safe(Inc)
    d if d <= -1 && d >= -3 -> Safe(Dec)
    _ -> Unsafe
  }
}

fn is_safe(state: State) -> Bool {
  case state {
    Safe(_) -> True
    _ -> False
  }
}
