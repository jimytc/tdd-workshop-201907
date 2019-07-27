# frozen_string_literal: true

class BudgetService
  attr_reader :budget_repo

  def initialize(repo)
    @budget_repo = repo
  end

  def query(start_date, end_date)
    return 0 if end_date < start_date

    @budget_repo.budgets_between(start_date, end_date).reduce(0) do |memo, budget|
      memo += budget.amount_between(start_date, end_date)
    end
  end
end
