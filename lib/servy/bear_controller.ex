defmodule Servy.BearController do
  alias Servy.Wildthings

  @templates_path Path.expand("../../templates/", __DIR__)

  def index(conv) do
    bears = Wildthings.list_bears()

    content = @templates_path |> Path.join("index.eex") |> EEx.eval_file(bears: bears)

    %{conv | status: 200, resp_body: content}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    content = @templates_path |> Path.join("show.eex") |> EEx.eval_file(bear: bear)

    %{conv | status: 200, resp_body: content}
  end

  def create(conv, params) do
    %{
      conv
      | status: 200,
        resp_body: "Created a #{params["type"]} bear and named #{params["name"]}"
    }
  end
end
