# frozen_string_literal: true

class Person < ApplicationRecord
  validates :first_name, :last_name, :passport_series, :passport_number, :passport_issued_by, :passport_issued_on,
            presence: true
end
