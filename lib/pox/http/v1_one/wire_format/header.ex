defmodule Pox.HTTP.V1One.WireFormat.Header do
  defmodule Element do
    defmodule Name do
      @type t :: String.t
    end

    defmodule Value do
      @type t :: String.t
    end

    @type t :: {Name.t, Value.t}

    def read(x) do
      x
      |> String.split(": ", parts: 2)
      |> List.to_tuple()
      |> _read()
    end

    def write(x) do
      x
      |> _write()
      |> Tuple.to_list()
      |> List.insert_at(_position = 1, _delimiter = [":", " "])
    end

    defp _read({"Content-Length", x}) when is_binary(x) do
      {"Content-Length", String.to_integer(x)}
    end

    defp _read(x) do
      x
    end

    defp _write({"Content-Length", x}) when is_integer(x) do
      {"Content-Length", Integer.to_string(x)}
    end

    defp _write(x) do
      x
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
    Enum.map(x, &Element.read(&1))
  end
end
