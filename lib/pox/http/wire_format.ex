defmodule Pox.HTTP.WireFormat do
  alias Pox.HTTP.WireFormat.StatusLine
  alias Pox.HTTP.WireFormat.Header
  alias Pox.HTTP.WireFormat.Body

  def write(x) do
    x |> data() |> IO.iodata_to_binary()
  end

  defmodule Fragment do
    def line(x) do
      x
      |> String.split("\r\n\r\n", parts: 2)
      |> parts(2)
      |> hd()
      |> String.split("\r\n")
      |> hd()
    end

    def header(x) do
      x
      |> String.split("\r\n\r\n", parts: 2)
      |> parts(2)
      |> hd()
      |> String.split("\r\n")
      |> tl()
    end

    def body(x) do
      x
      |> String.split("\r\n\r\n", parts: 2)
      |> parts(2)
      |> List.last()
    end

    defp parts(x, n) when length(x) === n do
      x
    end
  end

  def read(x) do
    i = Fragment.line(x)
    j = Fragment.header(x)
    k = Fragment.body(x)

    a = StatusLine.read(i)
    b = Header.read(j)
    c = Body.read(k)

    %Pox.HTTP.Response{
      status: a,
      header: b, 
      body:   c
    }
  end

  defp data(x) do
    [StatusLine.write(x),   "\r\n",
     Header.write(x), "\r\n", "\r\n",
     Body.write(x),   "\r\n"
    ]
  end
end
