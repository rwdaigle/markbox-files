defmodule MarkboxFiles.Auth.Domain do

  alias HTTPotion.Response
  alias Poison.Parser, as: JSON

  def access_token(domain) do
    url("api/v1/domains/#{domain}/access_token.json")
    |> HTTPotion.get([basic_auth: basic_auth])
    |> parse_response_body
    |> get_access_token
  end

  defp url(path), do: Application.get_env(:markbox_auth, :host) <> path

  defp process_request_headers(headers) do
    headers
    |> Dict.put :"User-Agent", "markbox-files"
    |> Dict.put :"Content-Type", "application/json"
  end

  defp parse_response_body(%Response{status_code: 200, body: body}), do: JSON.parse(body)
  defp parse_response_body(%Response{status_code: status_code}) do
    {:error, nil}
  end

  defp get_access_token({:ok, %{"access_token" => token}}), do: token
  defp get_access_token(_), do: nil

  defp basic_auth do
    {
      System.get_env("MARKBOX_AUTH_API_USER"),
      System.get_env("MARKBOX_AUTH_API_PASSWORD")
    }
  end

end
