defmodule Pox.Format.Line do
  def write(x) do
    [x.method, " ", x.path, " ", "HTTP/1.1"]
  end

  def read(x) do
    ["HTTP/1.1", number, text] = String.split(x, " ", parts: 3)
    {String.to_integer(number), text}
  end
end
