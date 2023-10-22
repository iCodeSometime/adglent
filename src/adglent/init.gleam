import priv/prompt
import priv/template
import priv/errors
import simplifile
import gleam/string
import gleam/list
import gleam/result

const aoc_toml_template = "
year = \"{{ year }}\"
session = \"{{ session }}\"
"

pub fn main() {
  let year = prompt.value("Year", "2023", False)
  let session = prompt.value("Session Cookie", "", False)

  let aoc_toml_file = "aoc.toml"
  let overwrite = case simplifile.create_file(aoc_toml_file) {
    Ok(_) -> True
    Error(simplifile.Eexist) ->
      prompt.confirm("aoc.toml exits - overwrite", False)
    _ -> panic as "Could not create aoc.toml"
  }
  case overwrite {
    True -> {
      template.render(
        aoc_toml_template,
        [#("year", year), #("session", session)],
      )
      |> simplifile.write(aoc_toml_file)
      |> errors.map_messages(
        "aoc.toml - written",
        "Error when writing aoc.toml",
      )
    }

    False -> Ok("aoc.toml - skipped")
  }
  |> errors.print_result

  case simplifile.is_file(".gitignore") {
    True -> {
      use gitignore <- result.try(
        simplifile.read(".gitignore")
        |> result.map_error(fn(err) {
          "Could not read .gitignore: " <> string.inspect(err)
        }),
      )
      let aoc_toml_ignored =
        string.split(gitignore, "\n")
        |> list.find(fn(line) { line == "aoc.toml" })
      case aoc_toml_ignored {
        Error(_) -> {
          simplifile.append("\naoc.toml", ".gitignore")
          |> errors.map_messages(
            ".gitignore written",
            "Error when writing .gitignore",
          )
        }
        Ok(_) -> Ok(".gitignore - skipped (already configured)")
      }
    }
    False -> Error("Could not find .gitignore")
  }
  |> errors.print_result
}
