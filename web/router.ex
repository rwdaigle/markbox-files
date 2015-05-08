defmodule MarkboxFiles.Router do
  use MarkboxFiles.Web, :router

  scope "/", MarkboxFiles do
    get "/*path", FileController, :show # "path" is needed for glob to match (bug?)
  end
end
