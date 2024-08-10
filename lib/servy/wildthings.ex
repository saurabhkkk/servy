defmodule Servy.Wildthings do
  alias Servy.Bear

  def list_bears() do
    [
      %Bear{id: 1, name: "Teddy", type: "Grizzly", hibernating: true},
      %Bear{id: 2, name: "Yogi", type: "Black", hibernating: false},
      %Bear{id: 3, name: "Baloo", type: "Brown", hibernating: true},
      %Bear{id: 4, name: "Smokey", type: "American Black", hibernating: false}
    ]
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn b -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer() |> get_bear()
  end
end
