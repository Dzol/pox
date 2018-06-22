defmodule Pox.HTTP.V1.Response do
  defmodule Status do
    @type t :: integer ## 100s, 200s, ...

    def known!(200) do
    end
    def known!(301) do
    end
    def known!(400) do
    end
    def known!(500) do
    end
  end

  @type t :: %__MODULE__{
    status: Pox.HTTP.V1.Response.StatusLine.t,
    header: Pox.HTTP.V1.WireFormat.Header.t,
    body:   <<>>
  }
  defstruct [
    status: 000,
    header: [],
    body:   <<>>
  ]
end
