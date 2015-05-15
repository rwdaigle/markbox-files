defmodule MarkboxFiles.Auth.Domain do

  alias HTTPotion.Response
  alias Poison.Parser, as: JSON

  def access_token(domain) do
    url("/api/v1/domains/#{domain}/access_token.json")
    |> HTTPotion.get([headers: headers])
    |> parse_response_body
    |> get_access_token
  end

  defp parse_response_body(%Response{status_code: 200, body: body}), do: JSON.parse(body)
  defp parse_response_body(%Response{status_code: 401, body: body}), do: {:error, "Could not authenticate against Auth service"}
  defp parse_response_body(%Response{status_code: status_code}) do
    {:error, nil}
  end

  defp get_access_token({:ok, %{"access_token" => token}}), do: token
  defp get_access_token(_), do: nil

  defp url(path), do: Application.get_env(:markbox_auth, :host) <> path

  defp headers do
    [
      "User-Agent": "markbox-files",
      "Content-Type": "application/json",
      "Authorization": "Basic #{basic_auth}"
    ]
  end

  defp basic_auth do
    Base.encode64(Application.get_env(:markbox_auth, :api_user) <> ":" <> Application.get_env(:markbox_auth, :api_password))
  end

end
