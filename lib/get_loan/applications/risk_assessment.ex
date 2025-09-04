defmodule GetLoan.Applications.RiskAssessment do
  @points %{
    "paying_job_now" => 4,
    "paying_job_12month" => 2,
    "own_home" => 2,
    "own_car" => 1,
    "additional_income" => 2
  }

  @minimum_acceptable_points 6

  def passed(answers) when is_map(answers) do
    total_points =
      answers
      |> Enum.map(&points_for/1)
      |> Enum.sum()

    total_points > @minimum_acceptable_points
  end

  defp points_for({_, "false"}), do: 0
  defp points_for({risk_key, "true"}), do: Map.get(@points, risk_key, 0)
end
