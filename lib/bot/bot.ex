defmodule AcmBot.Bot do
  @bot :acm_bot
  def bot(), do: @bot

  use Telex.Bot, name: @bot
  use Telex.Dsl

  require Logger

  def handle({:command, "start", msg}, name, _) do
    answer msg, "Hola! Soy el bot de <b>ACM UPM</b> 😃\nUsa /help para ver que puedo hacer.", bot: name, parse_mode: "HTML"
  end

  def handle({:command, "registergroup", %{from: %{id: uid}} = msg}, name, _) do
    Step.add_user(uid)
    markup = %Telex.Model.ForceReply{force_reply: true}
    answer msg, "Write the description", bot: name, reply_markup: markup
  end

  def handle({:text, text, %{from: %{id: uid}} = msg}, name, _) do
    case Step.get_step(uid) do
      {:ok, :description} ->
        Step.next(uid)
        markup = %Telex.Model.ForceReply{force_reply: true}
        # TODO: save description
        Logger.info "Description: #{inspect text}"
        answer msg, "Lovely description, now send me the group link", bot: name, reply_markup: markup
      {:ok, :link} ->
        Step.del_user(uid)
        # TODO: save link
        Logger.info "Link: #{inspect text}"
        answer msg, "Awesome! Group registered!", bot: name
      _ -> Logger.info "Not my problem dude"
    end
  end
end
