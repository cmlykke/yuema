import gleam/io
import gleam/dict
import gleam/result
import libraries/conwaylibrary/conwaylibrary

pub fn main() -> Nil {
  // Execute parse_conway_files and save the result to a variable
  let cangjie_dict = conwaylibrary.parse_conway_files()
  let size = case result.map(cangjie_dict, dict.size) {
    Ok(size) -> size
    Error(err) -> {
      io.println("Error parsing Conway files: " <> err)
      0 // Return 0 as a fallback for the error case
    }
  }
  echo size

  // Original print statement
  io.println("Hello from yuema! lykke 222333 xxxx")
}