defmodule MarkboxFile.Dropbox.File do

  alias HTTPotion.Response

  @dropbox_file_base Application.get_env(:dropbox, :file_host) <> Application.get_env(:dropbox, :file_base)

  @doc """
  Given a file path and the user's access token, get the contents of the file.

  ## Examples

      iex> user_access_token = Application.get_env(:dropbox, :access_token)
      iex> %{status: status, headers: headers, body: body} = MarkboxFile.Dropbox.File.get("/ryandaigle.com/index.html", user_access_token)
      iex> status
      200
      iex> Dict.fetch!(headers, :"Content-Type")
      "text/html; charset=utf-8"
      iex> body
      "<h4>Live from Dropbox!</h4>\\n"

  Error conditions:

      iex> %{status: status} = MarkboxFile.Dropbox.File.get("/ryandaigle.com/index.html", "invalid")
      iex> status
      401
  """
  def get(path, access_token) do
    file_url(path)
    |> HTTPotion.get([headers: headers(access_token)])
    |> parse_response
  end

  defp parse_response(%Response{status_code: status, body: body, headers: headers}) do
    # IO.inspect(headers)
    %{status: status, headers: headers, body: body}
  end

  defp file_url(path), do: @dropbox_file_base <> path

  defp headers(access_token) do
    ["User-Agent": "dropbox_delta.ex", "Authorization": "Bearer #{access_token}"]
  end
end
