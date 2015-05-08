defmodule MarkboxFiles.FileController do
  use MarkboxFiles.Web, :controller
  alias MarkboxFile.Dropbox.File, as: DBFile

  plug :action

  def show(conn, _params) do
    # Add wilcard path routing
    # Add path recognition
    token = Application.get_env(:dropbox, :user_access_token)
    {:ok, contents} = DBFile.contents("/ryandaigle.com/index.html", token)
    text conn, contents
  end
end
