import gleam/io
import libraries/cangjielibrary/cangjielibrary // Import the cangjielibrary module
import libraries/dataresultlibrary/fileoutput

pub fn main() -> Nil {
  // Execute parse_cangjie_file and save the result to a variable
  let cangjie_dict = cangjielibrary.parse_codes_with_multiple_characters("")
  //let formatted = fileoutput.write_code_to_characters(cangjie_dict, "cangjieoverlaps")
  //io.debug(formatted)

  // Original print statement
  io.println("Hello from yuema! lykke 222333 xxxx")
}