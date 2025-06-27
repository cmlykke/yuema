import gleam.{type Result}
import gleam/dict.{type Dict}
import gleam/set.{type Set}
import gleam/list
import gleam/string

pub fn format_code_to_characters(result: Result(Dict(String, Set(String)), String)) -> List(String) {
  case result {
    Ok(code_dict) -> {
      // Convert dictionary to list of formatted strings
      let formatted_list = dict.to_list(code_dict)
      |> list.map(fn(pair) {
        let #(code, chars) = pair
        // Convert set to list and join with spaces
        let chars_string = set.to_list(chars)
        |> string.join(with: " ")
        // Format as "key value1 value2 ..."
        code <> " " <> chars_string
      })
      // Sort alphabetically by key (since key is first in each string, simple sort works)
      |> list.sort(string.compare)

      formatted_list
    }
    Error(_) -> []
  }
}