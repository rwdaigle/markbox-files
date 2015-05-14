defmodule MarkboxFiles.FileController do

  use MarkboxFiles.Web, :controller
  alias MarkboxFiles.Dropbox.File, as: Dropbox
  alias MarkboxFiles.Auth.Domain

  plug :action

  def show(conn, params) do
    file =
      conn
      |> get_dropbox_file_path(params)
      |> Dropbox.get(dropbox_user_access_token(conn, params))

    conn
    |> set_headers(file)
    |> send_file(file)
  end

  defp get_dropbox_file_path(conn, params), do: "/#{domain(conn, params)}#{full_path(conn)}"

  defp set_headers(conn, %{headers: headers}) do
    headers
    |> Keyword.take(transferrable_headers)
    |> Enum.reduce(conn, fn({h, v}, c) -> put_resp_header(c, to_string(h), v) end)
  end

  defp transferrable_headers do
    [:"Content-Type", :"Content-Length", :"Cache-Control", :etag]
  end

  defp send_file(conn, %{body: body, status: status}) do
    send_resp(conn, status, body)
  end

  defp dropbox_user_access_token(conn, params) do
    Domain.access_token(domain(conn, params))
  end

  defp domain(_conn, %{"domain" => domain}), do: domain
  defp domain(conn, _params) do
    case conn.host do
      "localhost" -> "ryandaigle.com"
      host -> host
    end    
  end
end
