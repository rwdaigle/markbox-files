defmodule MarkboxFiles.Scrolls do

  use Timex
  import Logger

  def log(params) when is_list(params) do
    params
    |> Enum.map(fn {k, v} -> "#{to_string(k)}=#{to_string(v)}" end)
    |> Enum.reduce("", fn(e, acc) -> "#{acc}#{e} " end)
    |> Logger.info
  end

  def log(params, func) when is_list(params) and is_function(func) do
    try do
      start = Time.to_msecs(Time.now)
      ret_value = func.()
      service_ms = Time.to_msecs(Time.now) - start
      List.insert_at(params, 0, {:service, "#{service_ms}ms"}) |> log
      ret_value
    rescue
      e -> List.insert_at(params, 0, {:error, e}) |> log
      raise e
    end
  end
end
