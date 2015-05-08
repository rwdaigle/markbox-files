defmodule MarkboxFile.Dropbox.File do

  alias HTTPotion.Response

  @dropbox_file_base Application.get_env(:dropbox, :file_host) <> Application.get_env(:dropbox, :file_base)

  @doc """
  Given a file path and the user's access token, get the contents of the file.

  ## Examples

      iex> user_access_token = Application.get_env(:dropbox, :access_token)
      iex> MarkboxFile.Dropbox.File.contents("/ryandaigle.com/index.html", user_access_token)
      {:ok, "Live from Dropbox!"}

  Error conditions:

      iex> MarkboxFile.Dropbox.File.contents("/ryandaigle.com/index.html", "invalid")
      {:error, 401, :body, "{\"error\": \"Invalid OAuth2 token.\"}"}
  """
  def contents(path, access_token) do
    file_url(path)
    |> HTTPotion.get([headers: headers(access_token)])
    |> handle_response
  end

  defp handle_response(%Response{status_code: 200, body: body}), do: {:ok, body}
  defp handle_response(%Response{status_code: status, body: body}), do: {:error, status, :body, body}

  defp file_url(path), do: @dropbox_file_base <> path

  defp headers(access_token) do
    ["User-Agent": "dropbox_delta.ex", "Authorization": "Bearer #{access_token}"]
  end
end
