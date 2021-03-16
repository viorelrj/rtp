

defmodule ConnectionItem do
  use Agent

  def start_link(opts) do
    {url} = parse_options(opts)
    EventsourceEx.new(url, stream_to: self())
    recv()
  end

  defp parse_options(opts) do
    url = opts[:url]
    {url}
  end

  defp recv() do
    receive do
      tweet -> Router.route(tweet.data)
    end
    recv()
  end
end
