defmodule Pox.HTTP.Format.Header do
  defmodule Element do
    @type t :: {String.t, String.t}

    def read(x) do
      String.split(x, ": ", parts: 2)
    end
  end

  @type t :: [Element.t]

  def write(x) do
    x
    |> Map.get(:header)
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&List.insert_at(&1, 1, [":", " "]))
    |> Enum.intersperse("\r\n")
  end

  def read(x) do
    Enum.map(x, &List.to_tuple(Element.read(&1)))
  end
end
