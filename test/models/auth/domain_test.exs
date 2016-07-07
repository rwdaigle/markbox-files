defmodule MarkboxFiles.Auth.DomainTest do

  use ExUnit.Case, async: false
  alias MarkboxFiles.Auth.Domain

  test "access token" do
    assert Domain.access_token("ryandaigle.com") == "access-token"
  end
end
