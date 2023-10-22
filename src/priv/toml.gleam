import gleam/dynamic.{Decoder, Dynamic}
import gleam/result

pub type Toml

pub fn get_string(
  toml_content: String,
  key_path: List(String),
) -> Result(String, Nil) {
  use toml <- result.try(parse(toml_content))
  toml
  |> decode(key_path, dynamic.string)
}

fn decode(
  from toml: Toml,
  get key_path: List(String),
  expect decoder: Decoder(a),
) -> Result(a, Nil) {
  use item <- result.try(do_toml_get(toml, key_path))
  item
  |> decoder()
  |> result.map_error(fn(_err) { Nil })
}

@target(erlang)
@external(erlang, "adglent_ffi", "toml_get")
pub fn do_toml_get(toml: Toml, keys: List(String)) -> Result(Dynamic, Nil)

@target(erlang)
@external(erlang, "adglent_ffi", "toml_parse")
pub fn parse(content: String) -> Result(Toml, Nil)
