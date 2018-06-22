defmodule Pox.HTTP.V1.WireFormat.StatusLine do
  def write(x) do
    [x.method, " ", x.path, " ", "HTTP/1.1"]
  end

  def read(x) do
    [protocol, number, _text] = String.split(x, " ", parts: 3)
    "HTTP/1.1" = protocol
    number = String.to_integer(number)
    Pox.HTTP.V1.Response.Status.known!(number)
    number
  end
end
