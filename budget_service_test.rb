# frozen_string_literal: true

require 'minitest/autorun'
require 'rr'

require 'active_support'
require 'date'
require_relative './budget'
require_relative './budget_repo'
require_relative './budget_service'

class BudgetServiceTest < Minitest::Test

  def setup
    super
    @repo = BudgetRepo.new
    @service = BudgetService.new(@repo)
  end

  def test_invalid_query_range
    start_date, end_date = query_range_of('2019-03-31', '2019-03-01')
    budget_in_range_should_be(start_date, end_date, 0)
  end

  def test_entire_month_without_budgets
    given_budgets([])
    start_date, end_date = query_range_of('2019-03-01', '2019-03-31')
    budget_in_range_should_be(start_date, end_date, 0)
  end

  private

  def query_range_of(start_date_str, end_date_str)
    [Date.strptime(start_date_str, '%Y-%m-%d'), Date.strptime(end_date_str, '%Y-%m-%d')]
  end

  def given_budgets(budgets)
    mock(@repo).budgets { budgets }
  end

  def budget_in_range_should_be(start_date, end_date, expected)
    assert_equal expected, @service.query(start_date, end_date)
  end
end
