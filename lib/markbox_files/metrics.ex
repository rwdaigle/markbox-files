defmodule MarkboxFiles.Metrics do

  import Metrix

  def request(metadata, metric, fun) do

    response =
      metadata
      |> count("#{metric}.request")
      |> measure("#{metric}.request.service", fun)

    response_bytes =
      (response.headers[:"Content-Length"] || "0")
      |> Integer.parse
      |> elem(0)

    metadata
    |> Map.put("response_status", response.status_code)
    |> sample("#{metric}.response.size", "#{response_bytes / 1024}kb")

    response
  end
end
