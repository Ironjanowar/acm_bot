defmodule AcmBot do
  use Application
  def start, do: start(1, 1)

  require Logger

  def start(_, _) do
    import Supervisor.Spec

    children = [
      supervisor(Telex, []),
      supervisor(Acm.Upm, []),
      worker(Step, []),
      supervisor(AcmBot.Bot, [:updates, Application.get_env(:acm_bot, :token)])
    ]

    opts = [strategy: :one_for_one, name: AcmBot]
    case Supervisor.start_link(children, opts) do
      {:ok, _} = ok ->
        Logger.info "Starting AcmBot"
        ok
      error ->
        Logger.error "Error starting AcmBot"
        error
    end
  end
end
