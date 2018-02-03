defmodule Pox.Response do
  defmodule Status do
    @type t :: {integer, String.t}
  end

  @type t :: %__MODULE__{
    status: Pox.Response.Status.t,
    header: Pox.Format.Header.t,
    body:   String.t
  }
  defstruct [
    status: {000, ""},
    header: [],
    body:   ""
  ]
end
