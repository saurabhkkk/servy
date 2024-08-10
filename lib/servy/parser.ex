defmodule Servy.Parser do
  alias Servy.Conv, as: Conv

  def parse(request) do
    # TODO: Parse the reqeust string into map
    [top, params_string] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines, %{})

    params = parse_params(headers["Content-Type"], params_string)

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_headers([head | tail], headers) when head != "" do
    # IO.puts("HEAD: is #{inspect(head)} TAIL: is #{inspect(tail)}")

    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  def parse_headers(["" | tail], headers), do: parse_headers(tail, headers)

  def parse_headers([], headers), do: headers

  @doc """
  Parses the given param string of the `key1=value1&key2=value2`
  into a map with corresponding keys and values
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end

  def parse_params(_, _), do: %{}
end
