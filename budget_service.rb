# frozen_string_literal: true

require_relative 'period.rb'

class BudgetService
  attr_reader :budget_repo

  def initialize(repo)
    @budget_repo = repo
  end

  def query(start_date, end_date)
    period = Period.new(start_date, end_date)
    return 0 unless period.valid?

    @budget_repo.budgets
                &.map { |budget| budget.overlapping_amount(period) }
                &.sum || 0
  end
end
