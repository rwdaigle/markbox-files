defmodule MarkboxFiles.FileController do
  use MarkboxFiles.Web, :controller
  alias MarkboxFile.Dropbox.File, as: Dropbox

  plug :action

  def show(conn, params) do
    conn
    |> get_dropbox_file_path
    |> Dropbox.get(dropbox_user_access_token(conn, params))
    |> set_headers(conn)
    |> send_response(conn)
  end

  defp get_dropbox_file_path(conn) do
    # Add domain recognition
    "/ryandaigle.com#{full_path(conn)}"
  end

  defp set_headers(file, conn) do
    content_type = file
      |> Dict.fetch!(:headers)
      |> Keyword.get(:"Content-Type")
    put_resp_content_type(conn, content_type)
    file
  end

  defp send_response(%{body: body}, conn), do: text(conn, body)

  defp dropbox_user_access_token(_conn, _params) do
    Application.get_env(:dropbox, :user_access_token)
  end
end
