require 'csv'

module Volksbanker
  class Line
    DATE_FORMAT = '%d.%m.%Y'

    def self.parse(str)
      CSV.parse(str, col_sep: ';') { |row| return new(*row) }
    end

    def parse_date(str)
      Date.strptime str, DATE_FORMAT if str
    end

    def parse_amount(amt, dir)
      amount = parse_number amt
      amount *= -1 unless credit?(dir)
      amount
    end

    private

    def parse_number(str)
      str.               # There must be a better way to do this!
        gsub('.', '').   # no thousand-separator
        gsub(',', '.').  # use decimal point instead of comma for decimal separator
        to_f
    end

    def credit?(str)
      str == 'H'
    end
  end
end
