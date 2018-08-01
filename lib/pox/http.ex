defmodule Pox.HTTP do

  @spec service(Pox.HTTP.V1One.Request.t()) :: Pox.HTTP.V1One.Response.t()
  def service(request) do
    # %Pox.HTTP.V1One.Request{header: %{"Host" => x}} = request
    host = request
           |> Map.fetch!(:header)
           |> List.keyfind("Host", 0)
           |> Kernel.elem(1)
           |> host()
           |> Kernel.to_charlist()
    port = request
           |> Map.fetch!(:header)
           |> List.keyfind("Host", 0)
           |> Kernel.elem(1)
           |> port()
    service(request, host, port)
  end

  @spec service(Pox.HTTP.V1One.Request.t(), String.t(), integer()) :: Pox.HTTP.V1One.Response.t()
  defp service(x, host, port) do
    x
    |> Pox.HTTP.V1One.WireFormat.write()
    |> socket(host, port)
    |> Pox.HTTP.V1One.WireFormat.read()
  end

  @spec socket(String.t(), String.t(), integer()) :: String.t()
  defp socket(data, host, port) do
    alias :gen_tcp, as: TCP

    {:ok, socket} = TCP.connect(host, port, [:binary, packet: 0] ++ passive())
    :ok = TCP.send(socket, data)
    {:ok, response} = TCP.recv(socket, 0)
    TCP.close(socket)
    response
  end

  @spec host(String.t()) :: String.t()
  defp host(x) do
    List.first(String.split(x, ":"))
  end

  @spec port(String.t()) :: integer()
  defp port(x) do
    default = 80
    case String.split(x, ":") do
      [_] ->
        default
      [_|x] ->
        String.to_integer(x)
    end
  end

  @spec passive() :: [{:active, false}]
  defp passive do
    [{:active, false}]
  end
end
