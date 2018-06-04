defmodule Pox.HTTP.WireFormat.Header do
  defmodule Element do
    defmodule Name do
      @type t :: String.t
    end

    defmodule Value do
      @type t :: String.t
    end

    @type t :: {Name.t, Value.t}

    def read(x) do
      String.split(x, ": ", parts: 2)
    end

    def write(x) do
      x
      |> Tuple.to_list()
      |> List.insert_at(_position = 1, _delimiter = [":", " "])
    end
  end

  @type t :: [Element.t]

  def write(x) do
    x
    |> Map.get(:header)
    |> Enum.map(&Element.write/1)
    |> Enum.intersperse("\r\n")
  end

  def read(x) do
    Enum.map(x, &List.to_tuple(Element.read(&1)))
  end
end
