defmodule MarkboxFiles.FileController do

  use MarkboxFiles.Web, :controller
  alias MarkboxFiles.Dropbox.File, as: Dropbox
  alias MarkboxFiles.Auth.Domain
  alias MarkboxFiles.Metrics

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

  defp get_dropbox_file_path(conn, params), do: "/#{domain(conn, params)}#{path(conn)}"

  defp set_headers(conn, %{headers: headers}) do
    headers
    |> Keyword.take(transferrable_headers)
    |> Keyword.put(:"cache-control", "public, max-age=#{max_age}")
    |> Enum.reduce(conn, fn({h, v}, c) -> put_resp_header(c, to_string(h), v) end)
  end

  defp transferrable_headers, do: [:"Content-Type", :etag]

  defp send_file(conn, %{body: body, status: status}) do
    send_resp(conn, status, body)
  end

  defp dropbox_user_access_token(conn, params) do
    Domain.access_token(domain(conn, params))
  end

  defp domain(_conn, %{"domain" => domain}), do: domain
  defp domain(conn, _params) do
    if Enum.member?(Application.get_env(:default, :inbound_domains), conn.host) do
      Application.get_env(:default, :target_domain)
    else
      conn.host
    end
  end

  defp path(conn) do
    case full_path(conn) do
      "/" -> "/index.html"
      path -> path
    end
  end

  defp max_age do
    22896000
  end
end
