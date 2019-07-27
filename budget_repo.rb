# frozen_string_literal: true

class BudgetRepo
  def budgets; end

  def budgets_between(start_date, end_date)
    budgets.select { |budget| budget.in?(start_date, end_date) }
  end
end
