# frozen_string_literal: true

require 'date'
require 'active_support'

class Budget
  attr_reader :year_month, :amount

  def initialize(year_month, amount)
    @year_month = year_month
    @amount = amount
  end

  def overlapping_amount(period)
    daily_amount * month_period.overlapping_day_count(period)
  end

  private

  def daily_amount
    1.0 * amount / day_count
  end

  def month_period
    Period.new(first_day, last_day)
  end

  def first_day
    Date.strptime(year_month, '%Y%m')
  end

  def last_day
    first_day.next_month - 1
  end

  def day_count
    month_period.day_count
  end
end
