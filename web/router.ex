defmodule MarkboxFiles.Router do
  use MarkboxFiles.Web, :router

  pipeline :browser do
    plug :accepts, ["*"]
  end

  scope "/", MarkboxFiles do
    pipe_through :browser # Use the default browser stack

    get "/", FileController, :show
  end
end
