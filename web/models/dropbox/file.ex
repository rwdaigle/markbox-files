defmodule MarkboxFiles.Dropbox.File do

  alias MarkboxFiles.Metrics
  alias HTTPotion.Response

  @dropbox_file_url Application.get_env(:dropbox, :file_host) <> Application.get_env(:dropbox, :file_base)

  @doc """
  Given a file path and the user's access token, get the contents of the file.

  ## Examples

      iex> user_access_token = Application.get_env(:dropbox, :access_token)
      iex> %{status: status, headers: headers, body: body} = MarkboxFiles.Dropbox.File.get("/ryandaigle.com/index.html", user_access_token)
      iex> status
      200
      iex> Dict.fetch!(headers, :"Content-Type")
      "text/html; charset=utf-8"
      iex> body
      "<h4>Live from Dropbox!</h4>\\n"

  Error conditions:

      iex> %{status: status} = MarkboxFiles.Dropbox.File.get("/ryandaigle.com/index.html", "invalid")
      iex> status
      401
  """
  def get(_path, nil), do: %{status: 500, headers: [], body: "Access token for this domain could not be retrieved"}
  def get(path, access_token) do
    Metrics.request(%{url: @dropbox_file_url, path: path}, "api.dropbox", fn(%{url: dropbox_url}) ->
      HTTPotion.post(dropbox_url, [headers: headers(path, access_token), timeout: timeout])
    end)
    |> parse_response
  end

  defp parse_response(%Response{status_code: status, body: body, headers: headers}) do
    %{status: status, headers: headers, body: body}
  end

  defp headers(path, access_token) do
    [
      "User-Agent": "markbox-files",
      "Authorization": "Bearer #{access_token}",
      "Dropbox-API-Arg": "{\"path\": \"#{path}\"}"
    ]
  end

  defp timeout do
    {int, _} = Application.get_env(:dropbox, :file_timeout) |> Integer.parse
    int
  end
end
