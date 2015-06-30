defmodule MarkboxFiles.Auth.DomainTest do

  use ExUnit.Case, async: false
  import Mock
  alias MarkboxFiles.Auth.Domain

  test "access token" do
    body = ~s({"access_token": "abc123"})
    with_mock HTTPotion, [get: fn(_url, _headers) -> %HTTPotion.Response{status_code: 200, body: body} end] do
      assert Domain.access_token("ryandaigle.com") == "abc123"
      assert called HTTPotion.get(url, [headers: headers, timeout: 20000])
    end
  end

  test "access token failure" do
    body = ~s(Nasty stack trace)
    with_mock HTTPotion, [get: fn(_url, _headers) -> %HTTPotion.Response{status_code: 500, body: body} end] do
      assert Domain.access_token("ryandaigle.com") == nil
      assert called HTTPotion.get(url, [headers: headers, timeout: 20000])
    end
  end

  defp url, do: "http://127.0.0.1:5000/api/v1/domains/ryandaigle.com/access_token.json"

  defp headers do
    [
      "user-agent": "markbox-files",
      "content-type": "application/json",
      "authorization": "Basic #{auth_header}"
    ]
  end

  defp auth_header do
    Base.encode64("#{Application.get_env(:markbox_auth, :api_user)}:#{Application.get_env(:markbox_auth, :api_password)}")
  end
end
