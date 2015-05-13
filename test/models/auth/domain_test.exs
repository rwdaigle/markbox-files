defmodule MarkboxFiles.Auth.DomainTest do

  use ExUnit.Case, async: false
  import Mock
  alias MarkboxFiles.Auth.Domain

  test "access token" do
    body = ~s({"access_token": "abc123"})
    with_mock HTTPotion, [get: fn(_url, _headers) -> %HTTPotion.Response{status_code: 200, body: body} end] do
      assert Domain.access_token("ryandaigle.com") == "abc123"
      assert called HTTPotion.get(url, [basic_auth: basic_auth])
    end
  end

  test "access token failure" do
    body = ~s(Nasty stack trace)
    with_mock HTTPotion, [get: fn(_url, _headers) -> %HTTPotion.Response{status_code: 500, body: body} end] do
      assert Domain.access_token("ryandaigle.com") == nil
      assert called HTTPotion.get(url, [basic_auth: basic_auth])
    end
  end

  defp url, do: Application.get_env(:markbox_auth, :host) <> "api/v1/domains/ryandaigle.com/access_token.json"
  defp basic_auth, do: {System.get_env("MARKBOX_AUTH_API_USER"), System.get_env("MARKBOX_AUTH_API_PASSWORD")}
end
