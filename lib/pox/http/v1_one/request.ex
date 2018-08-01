defmodule Pox.HTTP.V1One.Request do
  @type t :: %__MODULE__{
    method: String.t,
    path: String.t,
    header: Pox.HTTP.V1One.WireFormat.Header.t,
    body: String.t
  }
  defstruct [
    method: "GET",
    path: "/",
    header: [],
    body: ""
  ]

  def method(request, name)
  when name == "GET"
  when name == "HEAD"
  when name == "POST"
  when name == "PUT"
  when name == "DELETE"
  when name == "CONNECT"
  when name == "OPTIONS"
  when name == "TRACE"
  when name == "PATCH" do
    %__MODULE__{request | method: name}
  end

  def path(request, x) when is_binary(x) do
    %__MODULE__{request | path: x}
  end

  def header(request, name, value) when is_binary(name) and is_binary(value) do
    Map.update!(request, :header, &List.keystore(&1, name, 0, {name, value}))
  end

  def body(request, x) when is_binary(x) do
    %__MODULE__{request | body: x}
  end
end
