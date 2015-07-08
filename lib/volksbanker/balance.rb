require 'csv'
require 'volksbanker/line'

module Volksbanker
  class Balance < Line
    attr_reader :amount, :currency, :date

    def initialize(date, _, _, _, _, _, currency, _, amount, credit_or_debit)
      @date = parse_date date
      @currency = currency
      @amount = parse_amount amount, credit_or_debit
    end

    def to_s
      "#{date}: #{'%.2f' % amount} #{currency}"
    end
  end
end
