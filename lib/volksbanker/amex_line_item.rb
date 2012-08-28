module Volksbanker

  class AmexLineItem
    DATE_FORMAT = '%d/%m/%Y'

    attr_reader :amount, :description

    def initialize(date, amount, description)
      @date = date
      @amount = amount
      @description = description
    end

    def date
      @date.strftime DATE_FORMAT
    end
  end

end
