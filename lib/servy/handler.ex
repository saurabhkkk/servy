defmodule Servy.Handler do
  @moduledoc """
  Handles http request
  """

  alias Servy.Conv
  alias Servy.BearController
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.Filehandler, only: [handle_file: 2]
  @pages_path Path.expand("../../pages/", __DIR__)

  def handle(request) do
    request
    |> parse
    |> rewrite_path()
    |> log()
    |> route
    |> track()
    |> format_response
  end

  # def route(conv) do
  #   route(conv, conv.method, conv.path)
  # end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    IO.puts("params map is #{inspect(params)}")
    BearController.show(conv, params)
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Tigers Loins"}
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  # def route(%{method: "GET", path: "/about"} = conv) do
  #   # case File.read("pages/about.html") do
  #   #   {:ok, content} -> %{conv | status: 200, resp_body: content}
  #   #   {:error, :enoent} -> %{conv | status: 404, resp_body: "File not Found"}
  #   #   {:error, reason} -> %{conv | status: 500, resp_body: "File Error #{reason}"}
  #   # end
  # end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "#{path} not found"}
  end

  def format_response(%Conv{} = conv) do
    # TODO: Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: "#{conv.resp_content_type}"
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handle(request))

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handle(request))

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handle(request))

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handle(request))

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handle(request))

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

IO.puts(Servy.Handler.handle(request))
