defmodule MarkboxFiles.Metrics do

  import Logger

  def measure(metric, fun), do: Map.new |> measure(metric, fun)
  def measure(params, metric, fun) do
    {service_us, value} = cond do
      is_function(fun, 0) -> :timer.tc(fun)
      is_function(fun, 1) -> :timer.tc(fun, [params])
    end
    params |> Map.put("measure##{metric}", "#{service_us / 1000}ms") |> log
    value
  end

  def count(metric), do: count(metric, 1)
  def count(params, metric) when is_map(params), do: count(params, metric, 1)
  def count(metric, num) when is_number(num), do: Map.new |> count(metric, num)
  def count(params, metric, num) when is_map(params) and is_number(num) do
    params
    |> Map.put("count##{metric}", num)
    # |> log
  end

  # def metric(%{count: name} = params) do
  #   params
  #   |> Map.put("count##{name}", 1)
  #   |> Map.delete(:count)
  #   |> metric
  # end
  #
  # def metric(%{measure: name} = params) do
  #   params
  #   |> Map.put("measure##{name}", 1)
  #   |> Map.delete(:measure)
  #   |> metric
  # end

  def log(params) do
    params
    |> Enum.map(fn {k, v} -> "#{to_string(k)}=#{to_string(v)}" end)
    |> Enum.reduce("", fn(e, acc) -> "#{acc}#{e} " end)
    |> Logger.info
    params
  end
end
