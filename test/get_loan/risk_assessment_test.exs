defmodule GetLoan.RiskAssessmentTest do
  alias GetLoan.Applications.RiskAssessment
  use GetLoan.DataCase

  describe "RiskAssessment" do
    test "passed/1 returns true when scored more than @minimum_acceptable_points" do
      # total 7 points
      answers = %{
        "paying_job_now" => "true",
        "paying_job_12month" => "true",
        "own_home" => "false",
        "own_car" => "true",
        "additional_income" => "false"
      }

      assert RiskAssessment.passed(answers) == true
    end

    test "passed/1 returns true when scored less or equal to @minimum_acceptable_points" do
      # total 6 points
      answers = %{
        "paying_job_now" => "true",
        "paying_job_12month" => "true",
        "own_home" => "false",
        "own_car" => "false",
        "additional_income" => "false"
      }

      assert RiskAssessment.passed(answers) == false
    end
  end
end
