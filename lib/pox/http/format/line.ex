defmodule Pox.HTTP.Format.Line do
  def write(x) do
    [x.method, " ", x.path, " ", "HTTP/1.1"]
  end

  def read(x) do
    [protocol, number, text] = String.split(x, " ", parts: 3)
    "HTTP/1.1" = protocol
    true = Enum.member?(Pox.HTTP.Response.Status.table(), {String.to_integer(number), text})
    String.to_integer(number)
  end
end
