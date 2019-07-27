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

  def test_entire_month_with_budget_amount_zero
    given_budgets([Budget.new('201903', 0)])
    start_date, end_date = query_range_of('2019-03-01', '2019-03-31')
    budget_in_range_should_be(start_date, end_date, 0)
  end

  def test_entire_month_with_valid_budgets
    given_budgets([Budget.new('201903', 3100), Budget.new('201904', 30_000)])
    start_date, end_date = query_range_of('2019-03-01', '2019-03-31')
    budget_in_range_should_be(start_date, end_date, 3100)
  end

  def test_three_entire_months
    given_budgets([Budget.new('201903', 3100),
                   Budget.new('201904', 30_000),
                   Budget.new('201905', 310)])
    start_date, end_date = query_range_of('2019-03-01', '2019-05-31')
    budget_in_range_should_be(start_date, end_date, 33_410)
  end

  def test_partial_start_month
    given_budgets([Budget.new('201903', 3100),
                   Budget.new('201904', 30_000),
                   Budget.new('201905', 310)])
    start_date, end_date = query_range_of('2019-03-31', '2019-05-31')
    budget_in_range_should_be(start_date, end_date, 30_410)
  end

  def test_partial_start_and_end
    given_budgets([Budget.new('201903', 3100),
                   Budget.new('201904', 30_000),
                   Budget.new('201905', 310)])
    start_date, end_date = query_range_of('2019-03-31', '2019-05-01')
    budget_in_range_should_be(start_date, end_date, 30_110)
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
