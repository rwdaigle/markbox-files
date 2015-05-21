defmodule MarkboxFiles.Dropbox.File do

  alias MarkboxFiles.Metrics
  alias HTTPotion.Response

  @dropbox_file_base Application.get_env(:dropbox, :file_host) <> Application.get_env(:dropbox, :file_base)

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
  def get(path, nil), do: %{status: 500, headers: [], body: "Access token for this domain could not be retrieved"}
  def get(path, access_token) do
    %{url: file_url(path)}
    |> Metrics.count("api.dropbox.request")
    |> Metrics.measure("api.dropbox.request.service", fn(%{url: dropbox_url}) ->
      dropbox_url      
      |> HTTPotion.get([headers: headers(access_token)])
      |> parse_response
    end)
  end

  defp parse_response(%Response{status_code: status, body: body, headers: headers}) do
    %{status: status, headers: headers, body: body}
  end

  defp file_url(path), do: @dropbox_file_base <> path

  defp headers(access_token) do
    ["User-Agent": "dropbox_delta.ex", "Authorization": "Bearer #{access_token}"]
  end
end
