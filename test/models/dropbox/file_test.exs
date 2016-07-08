defmodule FileTest do

  import Mock
  use ExUnit.Case, async: false
  alias MarkboxFiles.Dropbox.File, as: Dropbox

  @timeout 250

  # doctest Dropbox

  test "GET file" do
    {:ok, body} = File.read("test/fixtures/file.html")
    with_mock HTTPotion, [post: fn(_, _) -> %HTTPotion.Response{status_code: 200, body: body} end] do
      assert %{status: 200, headers: _, body: ^body} = Dropbox.get("/test/path.html", "12ab")
      assert called HTTPotion.post(file_url, [headers: headers("/test/path.html", "12ab"), timeout: 20000])
    end
  end

  test "GET file failed" do
    with_mock HTTPotion, [post: fn(_, _) -> %HTTPotion.Response{status_code: 409} end] do
      assert %{status: 409, headers: _, body: nil} = Dropbox.get("/test/path.html", "12ab")
      assert called HTTPotion.post(file_url, [headers: headers("/test/path.html", "12ab"), timeout: 20000])
    end
  end

  defp file_url do
    "https://content.dropboxapi.com/2/files/download"
  end

  defp headers(path, access_token) do
    [
      "User-Agent": "markbox-files",
      "Authorization": "Bearer #{access_token}",
      "Dropbox-API-Arg": "{\"path\": \"#{path}\"}"
    ]
  end
end
