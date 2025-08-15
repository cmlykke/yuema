import gleam/io
import gleam/dict as dict
import gleam/string
import gleam/list
import gleam/int
import simplifile

const file_path = "src/outputfiles/"

// Ensure the file title doesn't end with ".txt" so we don't duplicate the extension
fn strip_txt_extension(name: String) -> String {
  case string.ends_with(name, ".txt") {
    True -> {
      let len = string.length(name)
      string.slice(name, 0, len - 4)
    }
    False -> name
  }
}

// Convert Dict(String, String) to a formatted string
fn dict_string_string_to_string(d: dict.Dict(String, String)) -> String {
  let count = dict.size(d)
  let body =
    dict.to_list(d)
    |> list.map(fn(pair) {
      let #(key, value) = pair
      "Key: " <> key <> ", Value: " <> value
    })
    |> string.join("\n")

  // Add header with count, and mark empty clearly
  let body_nonempty = case count {
    0 -> "(empty)"
    _ -> body
  }

  "Count: " <> int.to_string(count) <> "\n" <> body_nonempty
}

pub fn dict_string_string(d: dict.Dict(String, String), file_title: String) -> Nil {
  let res = dict_string_string_to_string(d)
  let safe_title = strip_txt_extension(file_title)
  write_debug_to_file(res, safe_title, safe_title <> ".txt")
}

// Convert Dict(String, List(String)) to a formatted string
fn dict_string_list_to_string(d: dict.Dict(String, List(String))) -> String {
  let count = dict.size(d)
  let body =
    dict.to_list(d)
    |> list.map(fn(pair) {
      let #(key, values) = pair
      "Key: " <> key <> ", Value: [" <> string.join(values, ", ") <> "]"
    })
    |> string.join("\n")

  let body_nonempty = case count {
    0 -> "(empty)"
    _ -> body
  }

  "Count: " <> int.to_string(count) <> "\n" <> body_nonempty
}

pub fn dict_string_list(d: dict.Dict(String, List(String)), file_title: String) -> Nil {
  // Also log to console for quick visibility during tests
  io.println("dict_string_list size: " <> int.to_string(dict.size(d)))
  let res = dict_string_list_to_string(d)
  let safe_title = strip_txt_extension(file_title)
  write_debug_to_file(res, safe_title, safe_title <> ".txt")
}

// Convert List(String) to a formatted string
fn list_string_to_string(items: List(String)) -> String {
  items
  |> list.index_map(fn(item, index) {
    "Index: " <> int.to_string(index) <> ", Value: " <> item
  })
  |> string.join("\n")
}

pub fn list_string(items: List(String), file_title: String) -> Nil {
  let res = list_string_to_string(items)
  let safe_title = strip_txt_extension(file_title)
  write_debug_to_file(res, safe_title, safe_title <> ".txt")
}

// Write debug string to a file, returning Nil
pub fn write_debug_to_file(debug_content: String, file_title: String, file_name: String) -> Nil {
  // Ensure the output directory exists
  case simplifile.create_directory(file_path) {
    Ok(Nil) -> io.println("Output directory ensured: " <> file_path)
    Error(_) -> io.println("Note: Output directory may already exist")
  }

  // Always overwrite the file with the new content
  let content = file_title <> ":\n" <> debug_content
  let full_path = file_path <> file_name
  // Write replaces the file contents (overwrite semantics)
  case simplifile.write(full_path, content) {
    Ok(Nil) -> io.println("Overwrote " <> full_path)
    Error(err) -> io.println("Failed to write to " <> full_path <> ": " <> string.inspect(err))
  }

  Nil
}
