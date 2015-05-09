defmodule MarkboxFiles.FileControllerTest do

  import Mock
  use MarkboxFiles.ConnCase
  use ExUnit.Case, async: false

  @timeout 250

  test "GET /index.html" do
    {:ok, body} = File.read("test/fixtures/file.html")
    with_mock HTTPotion, [get: fn("https://api-content.dropbox.com/1/files/auto/notryandaigle.com/index.html", _) ->
      %HTTPotion.Response{status_code: 200, body: body} end] do
      conn = get conn, "http://notryandaigle.com/index.html"
      assert conn.status == 200
      assert conn.resp_body == body
      assert called HTTPotion.get("https://api-content.dropbox.com/1/files/auto/notryandaigle.com/index.html", [headers: headers])
    end
  end

  defp headers do
    ["User-Agent": "dropbox_delta.ex", "Authorization": "Bearer #{Application.get_env(:dropbox, :user_access_token)}"]
  end
end
