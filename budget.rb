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
    d_year_month = Date.strptime(year_month, '%Y%m')
    year_month.between?(start_date.strftime('%Y%m'), end_date.strftime('%Y%m'))
  end
end
