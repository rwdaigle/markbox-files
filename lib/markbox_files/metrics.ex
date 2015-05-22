defmodule MarkboxFiles.Metrics do

  import Logger

  def request(params, metric, fun) do
    {metrics, response} =
      params
      |> count("#{metric}.request")
      |> measure("#{metric}.request.service", fun)

    response_bytes =
      (response.headers[:"Content-Length"] || "0")
      |> Integer.parse
      |> elem(0)

    metrics
    |> Map.put("response_status", response.status_code)
    |> sample("#{metric}.response.size", "#{response_bytes / 1024}kb")
    |> log

    response
  end

  def measure(metric, fun), do: Map.new |> measure(metric, fun)
  def measure(params, metric, fun) do
    {service_us, value} = cond do
      is_function(fun, 0) -> :timer.tc(fun)
      is_function(fun, 1) -> :timer.tc(fun, [params])
    end
    log_params = params |> Map.put("measure##{metric}", "#{service_us / 1000}ms")
    {log_params, value}
  end

  def count(metric), do: count(metric, 1)
  def count(params, metric) when is_map(params), do: count(params, metric, 1)
  def count(metric, num) when is_number(num), do: count(Map.new, metric, num)
  def count(params, metric, num) when is_map(params) and is_number(num) do
    Map.put(params, "count##{metric}", num)
  end

  def sample(metric, value), do: sample(Map.new, metric, value)
  def sample(params, metric, value) do
    Map.put(params, "sample##{metric}", value)
  end

  def log(params) do
    params
    |> Enum.map(fn {k, v} -> "#{to_string(k)}=#{to_string(v)}" end)
    |> Enum.reduce("", fn(e, acc) -> "#{acc}#{e} " end)
    |> IO.puts #Logger.info #IO.puts
    params
  end
end
