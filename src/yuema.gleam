import gleam/io
import gleam/dict
import gleam/result
import gleam/set
import libraries/conwaylibrary/conwaylibrary
import libraries/cangjielibrary/cangjielibrary
import libraries/dataresultlibrary/fileoutput
import libraries/big5andgeneralstadardlibrary/big5andgeneralstandard

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

  let big5andstandard = big5andgeneralstandard.parse_tzai7984andgeneralstandard_11825()
  let size2 = case result.map(big5andstandard, set.size) {
    Ok(size) -> size
    Error(err) -> {
      io.println("Error parsing Conway files: " <> err)
      0 // Return 0 as a fallback for the error case
    }
  }
  echo size2

  //parse_taiwan_20769()
  let taiwan_6343 = big5andgeneralstandard.parse_taiwanlesscommon_6343()


  let cangiewithmultiple = cangjielibrary.parse_codes_with_multiple_characters("")
  fileoutput.write_code_to_characters_set(cangiewithmultiple, "cangjieoverlap.txt")
  fileoutput.write_filtered_code_to_characters(cangiewithmultiple, big5andstandard, "cangjieoverlapSet.txt")
  fileoutput.write_set_to_characters(taiwan_6343, "Taiwan6343.txt")

  // Original print statement
  io.println("Hello from yuema! lykke 222333 xxxx")
}

