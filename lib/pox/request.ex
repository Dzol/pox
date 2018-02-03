defmodule Pox.Request do
  @type t :: %__MODULE__{
    method: String.t,
    path:   String.t,
    header: Pox.Format.Header.t,
    body:   String.t
  }
  defstruct [
    method: "GET",
    path:   "/",
    header: [],
    body:   ""
  ]
end
