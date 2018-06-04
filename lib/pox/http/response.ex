defmodule Pox.HTTP.Response do
  defmodule Status do
    @type t :: integer ## 100s, 200s, ...

    def known!(200, "OK") do
    end
    def known!(301, text) when text in ["Moved Permanently", "TLS Redirect"] do
    end
    def known!(400, "Bad Request") do
    end
    def known!(500, "Internal Server Error") do
    end
  end

  @type t :: %__MODULE__{
    status: Pox.HTTP.Response.StatusLine.t,
    header: Pox.HTTP.WireFormat.Header.t,
    body:   <<>>
  }
  defstruct [
    status: 000,
    header: [],
    body:   <<>>
  ]
end
