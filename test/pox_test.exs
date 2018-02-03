defmodule PoxTest do
  use ExUnit.Case

  test "write/1 + read/1" do
    alias :gen_tcp, as: TCP

    for host <- table() do
      q = %Pox.Request{
        method: "HEAD",
        header: [{"User-Agent", "Pox"}, {"Host", host}]
      }
      |> Pox.Format.write()
#      |> IO.inspect()

      {:ok, s} = TCP.connect(host, 80, [:binary, packet: 0] ++ passive())
      :ok = TCP.send(s, q); {:ok, r} = TCP.recv(s, 0)
      TCP.close(s)

      t = r
      |> Pox.Format.read()
#      |> IO.inspect()

      {i, _} = t.status; assert (i in 200..210) or (i in 300..310)
    end
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
