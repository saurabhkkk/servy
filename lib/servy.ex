defmodule Servy do
  def hello(name) do
    "welcome to new #{name}"
  end
end

IO.puts(Servy.hello("saurabh"))
