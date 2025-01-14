defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Parser

  test "parses a list of header feilds into a map" do
    header_line = ["A: 1", "B: 2"]
    headers = Parser.parse_headers(header_line, %{})

    assert headers = %{"A" => "1", "B" => "2"}
  end
end
