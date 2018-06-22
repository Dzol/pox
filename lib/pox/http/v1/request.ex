defmodule Pox.HTTP.V1.Request do
  @type t :: %__MODULE__{
    method: String.t,
    path:   String.t,
    header: Pox.HTTP.V1.WireFormat.Header.t,
    body:   String.t
  }
  defstruct [
    method: "GET",
    path:   "/",
    header: [],
    body:   ""
  ]
end
