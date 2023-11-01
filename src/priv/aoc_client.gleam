import gleam/result.{try}
import gleam/hackney.{type Error, Other}
import gleam/http/request
import gleam/dynamic
import gleam/int

pub fn get_input(
  year: String,
  day: String,
  session: String,
) -> Result(String, Error) {
  let assert Ok(request) =
    request.to(
      "https://adventofcode.com/" <> year <> "/day/" <> day <> "/input",
    )

  // Send the HTTP request to the server
  use response <- try(
    request
    |> request.prepend_header("Accept", "application/json")
    |> request.prepend_header("Cookie", "session=" <> session <> ";")
    |> hackney.send,
  )

  case response.status {
    status if status >= 200 && status < 300 -> Ok(response.body)
    status ->
      Error(Other(dynamic.from(int.to_string(status) <> " - " <> response.body)))
  }
}
