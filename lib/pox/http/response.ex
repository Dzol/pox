defmodule Pox.HTTP.Response do
  defmodule Status do
    @type t :: integer ## 100s, 200s, ...

    def table do
      [{200, "OK"},
       {400, "Bad Request"},
       {500, "Internal Server Error"}
      ]
    end
  end

  @type t :: %__MODULE__{
    status: Pox.HTTP.Response.Status.t,
    header: Pox.HTTP.Format.Header.t,
    body:   String.t
  }
  defstruct [
    status: 000,
    header: [],
    body:   ""
  ]
end
