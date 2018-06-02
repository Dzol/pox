defmodule Pox.HTTPTest do
  use ExUnit.Case

  test "write/1 + read/1" do
    alias :gen_tcp, as: TCP

    for host <- table() do
      q = %Pox.HTTP.Request{
        method: "HEAD",
        header: [{"User-Agent", "Pox"}, {"Host", host}]
      }
      |> Pox.HTTP.WireFormat.write()
#      |> IO.inspect()

      {:ok, s} = TCP.connect(host, 80, [:binary, packet: 0] ++ passive())
      :ok = TCP.send(s, q); {:ok, r} = TCP.recv(s, 0)
      TCP.close(s)

      t = r
      |> Pox.HTTP.WireFormat.read()
#      |> IO.inspect()

      i = t.status; assert (i in 200..210) or (i in 300..310)
    end
  end

  test "status line read" do
    assert_raise FunctionClauseError, fn ->
      Pox.HTTP.WireFormat.read("HTTP/1.1 200 OK")
    end
    assert_raise FunctionClauseError, fn ->
      Pox.HTTP.WireFormat.read("HTTP/1.1 200 OK\r\n")
    end
    assert Pox.HTTP.WireFormat.read("HTTP/1.1 200 OK\r\n\r\n") ===
      %Pox.HTTP.Response{
        body: "",
        header: [],
        status: 200
      }
  end

  defp table do
    ['www.google.com',
     'www.erlang-solutions.com',
     'www.wolframalpha.com',
     'en.wikipedia.org'
    ]
  end

  defp passive do
    [{:active, false}]
  end
end
