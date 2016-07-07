defmodule MarkboxFiles.Auth.Domain do
  def access_token(_domain), do: Application.get_env(:markbox_auth, :access_token)
end
