defmodule Pox.HTTP.V1OneTest do
  use ExUnit.Case

  @tag :system
  test "write/1 + read/1" do
    for host <- table() do
      ## Given:
      request = %Pox.HTTP.V1One.Request{
        method: "HEAD",
        header: [
          {"User-Agent", "Pox"},
          {"Host", host},
          {"Connection", "close"}
        ]
      }
      ## When:
      response = Pox.HTTP.service(request)
      ## Then:
      assert (response.status in 200..210) or (response.status in 300..310)
    end
  end

  test "status line read" do
    assert_raise FunctionClauseError, fn ->
      Pox.HTTP.V1One.WireFormat.read("HTTP/1.1 200 OK")
    end
    assert_raise FunctionClauseError, fn ->
      Pox.HTTP.V1One.WireFormat.read("HTTP/1.1 200 OK\r\n")
    end
    assert Pox.HTTP.V1One.WireFormat.read("HTTP/1.1 200 OK\r\n\r\n") ===
      %Pox.HTTP.V1One.Response{
        body: "",
        header: [],
        status: 200
      }
  end

  test "write/1 [Wikipedia]" do
    x = ["GET /index.html HTTP/1.1",
         "\r\n",
         "Host: www.example.com"
        ]
    x = Enum.join(x)
    q = %Pox.HTTP.V1One.Request{
      method: "GET",
      path: "/index.html",
      header: [{"Host", "www.example.com"}]
    }
    assert Pox.HTTP.V1One.WireFormat.write(q) =~ x
  end

  test "read/1 [Wikipedia]" do
    x = ["HTTP/1.1 200 OK",
         "Date: Mon, 23 May 2005 22:38:34 GMT",
         "Content-Type: text/plain; charset=UTF-8",
         "Content-Length: 13",
         "Last-Modified: Wed, 08 Jan 2003 23:11:55 GMT",
         "Server: Apache/1.3.3.7 (Unix) (Red-Hat/Linux)",
         "ETag: \"3f80f-1b6-3e1cb03b\"",
         "Accept-Ranges: bytes",
         "Connection: close"
        ]
    x = Enum.join(x, "\r\n") <> "\r\n" <> "\r\n" <> "Hello Elixir!"
    h = [
      {"Date", "Mon, 23 May 2005 22:38:34 GMT"},
      {"Content-Type", "text/plain; charset=UTF-8"},
      {"Content-Length", 13},
      {"Last-Modified", "Wed, 08 Jan 2003 23:11:55 GMT"},
      {"Server", "Apache/1.3.3.7 (Unix) (Red-Hat/Linux)"},
      {"ETag", "\"3f80f-1b6-3e1cb03b\""},
      {"Accept-Ranges", "bytes"},
      {"Connection", "close"}
    ]
    assert Pox.HTTP.V1One.WireFormat.read(x) === %Pox.HTTP.V1One.Response{
      body: "Hello Elixir!",
      header: h,
      status: 200
    }
  end

  defp table do
    ["www.google.com",
     "www.erlang-solutions.com",
     "www.wolframalpha.com",
     "en.wikipedia.org"
    ]
  end
end
