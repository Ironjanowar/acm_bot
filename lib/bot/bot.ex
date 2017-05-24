defmodule AcmBot.Bot do
  @bot :acm_bot
  def bot(), do: @bot

  use Telex.Bot, name: @bot
  use Telex.Dsl

  require Logger

  def handle({:command, "start", msg}, name, _) do
    answer msg, "Hola! Soy el bot de <b>ACM UPM</b> 😃\nUsa /help para ver que puedo hacer.", bot: name, parse_mode: "HTML"
  end

  def handle({:command, "register", msg}, name, _) do
    force_reply = %Telex.Model.ForceReply{force_reply: true}
    # No se como guardar el message_id de este a la que sale
    answer msg, "Dime la descripcion de este grupo", bot: name, reply_markup: force_reply
  end

  # def handle({:command, "registergroup", %{text: extra, chat: %{id: telegram_id, title: group_name}} = msg}, name, _) do
  #   data =
  #     String.split(extra, " ")
  #     |> List.to_tuple
  #     |> (fn x -> Enum.into([x], %{}) end).()

  #   case data do
  #     %{link: link, descrition: description} ->
  #       Acm.Upm.insert %Schemas.Group{telegram_id: telegram_id, name: group_name, description: description, link: link}
  #     %{link: link} ->
  #       Acm.Upm.insert %Schemas.Group{telegram_id: telegram_id, name: group_name, link: link}
  #     %{descrition: description} ->
  #       Acm.Upm.insert %Schemas.Group{telegram_id: telegram_id, name: group_name, description: description}
  #     _ ->
  #       Acm.Upm.insert %Schemas.Group{telegram_id: telegram_id, name: group_name}
  #   end

  #   Logger.info "Group #{group_name} [#{telegram_id}] registered"
  # end

  # def handle({:regex, "/(description:).+/i", _msg}, _name, _) do
  #   Logger.debug "Matchedd"
  # end

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
