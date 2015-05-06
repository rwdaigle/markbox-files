defmodule MarkboxFiles.PageController do
  use MarkboxFiles.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end
end
