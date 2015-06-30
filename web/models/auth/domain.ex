defmodule MarkboxFiles.Auth.Domain do

  alias HTTPotion.Response
  alias Poison.Parser, as: JSON
  alias MarkboxFiles.Metrics

  def access_token(domain) do
    Metrics.request(%{url: url("/api/v1/domains/#{domain}/access_token.json")}, "api.auth", fn(%{url: auth_url}) ->
      HTTPotion.get(auth_url, [headers: headers, timeout: timeout])
    end)
    |> parse_response_body
    |> get_access_token
  end

  defp parse_response_body(%{status_code: 200, body: body}), do: JSON.parse(body)
  defp parse_response_body(%{status_code: 401, body: body}), do: {:error, "Could not authenticate against Auth service"}
  defp parse_response_body(%{status_code: status_code}), do: {:error, nil}

  defp get_access_token({:ok, %{"access_token" => token}}), do: token
  defp get_access_token(_), do: nil

  defp url(path), do: Application.get_env(:markbox_auth, :host) <> path

  defp headers do
    [
      "user-agent": "markbox-files",
      "content-type": "application/json",
      "authorization": "Basic #{basic_auth}"
    ]
  end

  defp conn

  defp basic_auth do
    Base.encode64(Application.get_env(:markbox_auth, :api_user) <> ":" <> Application.get_env(:markbox_auth, :api_password))
  end

  defp timeout do
    {int, _} = Application.get_env(:markbox_auth, :timeout) |> Integer.parse
    int
  end

end
