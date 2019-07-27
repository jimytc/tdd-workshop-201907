# frozen_string_literal: true

require 'date'
require 'active_support'

class Budget
  attr_reader :year_month, :amount

  def initialize(year_month, amount)
    @year_month = year_month
    @amount = amount
  end

  def in?(start_date, end_date)
    year_month.between?(start_date.strftime('%Y%m'), end_date.strftime('%Y%m'))
  end

  def amount_between(start_date, end_date)
    return 0 unless in?(start_date, end_date)

    overlap_days(start_date, end_date) * amount / month_days
  end

  def overlap_days(start_date, end_date)
    month_start = Date.strptime(year_month, '%Y%m')
    current_start_date = [month_start, start_date].max
    month_end = Date.strptime(year_month, '%Y%m').next_month - 1
    current_end_date = [month_end, end_date].min
    (current_end_date - current_start_date).to_i + 1
  end

  def month_days
    month_start = Date.strptime(year_month, '%Y%m')
    month_end = Date.strptime(year_month, '%Y%m').next_month - 1
    (month_end - month_start).to_i + 1
  end
end
