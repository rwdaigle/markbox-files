defmodule MarkboxFiles.FileControllerTest do

  import Mock
  use MarkboxFiles.ConnCase
  use ExUnit.Case, async: false
  alias MarkboxFiles.Auth.Domain

  @timeout 250

  test "GET /index.html" do
    {:ok, file_body} = File.read("test/fixtures/file.html")
    with_mock HTTPotion, [post: fn("https://content.dropboxapi.com/2/files/download", _) ->
        %HTTPotion.Response{status_code: 200, body: file_body} end] do
      conn = get conn, "http://ryandaigle.com/index.html"
      assert conn.status == 200
      assert conn.resp_body == file_body
      assert called HTTPotion.post("https://content.dropboxapi.com/2/files/download", [headers: headers("/ryandaigle.com/index.html"), timeout: 20000])
    end
  end

  test "GET /index.html with domain parameter" do
    {:ok, file_body} = File.read("test/fixtures/file.html")
    with_mock HTTPotion, [post: fn("https://content.dropboxapi.com/2/files/download", _) ->
        %HTTPotion.Response{status_code: 200, body: file_body} end] do
      conn = get conn, "/index.html?domain=ryandaigle.com"
      assert conn.status == 200
      assert conn.resp_body == file_body
      assert called HTTPotion.post("https://content.dropboxapi.com/2/files/download", [headers: headers("/ryandaigle.com/index.html"), timeout: 20000])
    end
  end

  test "GET /" do
    {:ok, file_body} = File.read("test/fixtures/file.html")
    with_mock HTTPotion, [post: fn("https://content.dropboxapi.com/2/files/download", _) ->
        %HTTPotion.Response{status_code: 200, body: file_body} end] do
      conn = get conn, "http://ryandaigle.com/"
      assert conn.status == 200
      assert conn.resp_body == file_body
      assert called HTTPotion.post("https://content.dropboxapi.com/2/files/download", [headers: headers("/ryandaigle.com/index.html"), timeout: 20000])
    end
  end

  defp headers(path) do
    [
      "User-Agent": "markbox-files",
      "Authorization": "Bearer access-token",
      "Dropbox-API-Arg": "{\"path\": \"#{path}\"}"
    ]
  end
end
