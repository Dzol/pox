defmodule Pox.HTTP.WireFormat.StatusLine do
  def write(x) do
    [x.method, " ", x.path, " ", "HTTP/1.1"]
  end

  def read(x) do
    [protocol, number, _text] = String.split(x, " ", parts: 3)
    "HTTP/1.1" = protocol
    Pox.HTTP.Response.Status.known!(String.to_integer(number))
    String.to_integer(number)
  end
end
