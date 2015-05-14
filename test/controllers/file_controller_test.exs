defmodule MarkboxFiles.FileControllerTest do

  import Mock
  use MarkboxFiles.ConnCase
  use ExUnit.Case, async: false
  alias MarkboxFiles.Auth.Domain

  @timeout 250

  test "GET /index.html" do
    {:ok, file_body} = File.read("test/fixtures/file.html")
    with_mock HTTPotion, [get: fn("https://api-content.dropbox.com/1/files/auto/ryandaigle.com/index.html", _) ->
        %HTTPotion.Response{status_code: 200, body: file_body} end] do
      with_mock Domain, [access_token: fn(_) -> "abc123" end] do
        conn = get conn, "http://ryandaigle.com/index.html"
        assert conn.status == 200
        assert conn.resp_body == file_body
        assert called HTTPotion.get("https://api-content.dropbox.com/1/files/auto/ryandaigle.com/index.html", [headers: headers("abc123")])
      end
    end
  end

  test "GET /index.html with domain parameter" do
    {:ok, file_body} = File.read("test/fixtures/file.html")
    with_mock HTTPotion, [get: fn("https://api-content.dropbox.com/1/files/auto/ryandaigle.com/index.html", _) ->
        %HTTPotion.Response{status_code: 200, body: file_body} end] do
      with_mock Domain, [access_token: fn(_) -> "abc123" end] do
        conn = get conn, "/index.html?domain=ryandaigle.com"
        assert conn.status == 200
        assert conn.resp_body == file_body
        assert called HTTPotion.get("https://api-content.dropbox.com/1/files/auto/ryandaigle.com/index.html", [headers: headers("abc123")])
      end
    end
  end

  test "GET /" do
    {:ok, file_body} = File.read("test/fixtures/file.html")
    with_mock HTTPotion, [get: fn("https://api-content.dropbox.com/1/files/auto/ryandaigle.com/index.html", _) ->
        %HTTPotion.Response{status_code: 200, body: file_body} end] do
      with_mock Domain, [access_token: fn(_) -> "abc123" end] do
        conn = get conn, "http://ryandaigle.com/"
        assert conn.status == 200
        assert conn.resp_body == file_body
        assert called HTTPotion.get("https://api-content.dropbox.com/1/files/auto/ryandaigle.com/index.html", [headers: headers("abc123")])
      end
    end
  end

  defp headers(token) do
    ["User-Agent": "dropbox_delta.ex", "Authorization": "Bearer #{token}"]
  end
end
