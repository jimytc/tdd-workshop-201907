# frozen_string_literal: true

class Period
  attr_reader :start_date, :end_date

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def valid?
    end_date >= start_date
  end

  def day_count
    valid? ? (end_date - start_date).to_i + 1 : 0
  end

  def overlapping_day_count(another)
    period_start_date = [start_date, another.start_date].max
    period_end_date = [end_date, another.end_date].min
    Period.new(period_start_date, period_end_date)
          .day_count
  end
end