defmodule Mediator do
  def encode_topic(topic, content) do
    Poison.encode!(%{
      "type": "send",
      "topic": topic,
      "content": content
    })
  end

  def decode_topic(content) do
    {:ok, text} = Poison.decode(content)
    {text["topic"], text["content"]}
  end

end
