defmodule MarkboxFiles.Scrolls do

  import Logger

  def log(params) when is_map(params) do
    params
    |> Enum.map(fn {k, v} -> "#{to_string(k)}=#{to_string(v)}" end)
    |> Enum.reduce("", fn(e, acc) -> "#{acc}#{e} " end)
    |> Logger.info
  end

  def log(params, fun) when is_map(params) and is_function(fun) do
    try do
      {service_us, value} = cond do
        is_function(fun, 0) -> :timer.tc(fun)
        is_function(fun, 1) -> :timer.tc(fun, [params])
      end
      Dict.put(params, :service, "#{service_us / 1000}ms") |> log
      value
    rescue e ->
      if params[:event], do: params = %{params | event: "#{params[:event]}.error"}
      Dict.put(params, :message, Exception.message(e)) |> log
      raise e
    end
  end
end
