defmodule Worker do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle(_server, data) do
    case serialize(data) do
      {:ok, content} -> handle_success(content)
      {:error} -> handle_error()
    end
  end

  defp serialize(data) do
    case JSON.decode(data) do
      {:ok, content} -> {:ok, content}
      {:error, _error} -> handle_error()
    end
  end

  defp handle_success(content) do
    # message = Poison.decode!(tweet)["message"]

    tweet = content["message"]["tweet"]["text"]
    topic = content["message"]["tweet"]["lang"]
    tweet_score = Analysis.get_score(tweet)

    tweet_with_score = %{
      tweet: content["message"]["tweet"],
      score: tweet_score
    }
    Sink.add_tweet(tweet_with_score)
    ApiConnection.send_message(Mediator.encode_topic(topic, tweet))
  end

  defp handle_error() do
    {:error}
  end
end
