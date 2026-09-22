defmodule TimeManagerWeb.WorkingTimeJSON do
  alias TimeManager.WorkingTime

  def index(%{working_times: working_times}) do
    %{data: for(working_time <- working_times, do: data(working_time))}
  end

  def show(%{working_time: working_time}) do
    %{data: data(working_time)}
  end

  def data(%WorkingTime{} = working_time) do
    %{
      id: working_time.id,
      start: working_time.start,
      end: working_time.end,
      user_id: working_time.user_id
    }
  end
end
