class Event < ApplicationRecord
  before_save :set_completed

  private
  def set_completed
    completed = end_date > DateTime.current
  end
end
