module Volksbanker
  class Statement
    attr_reader :transactions, :opening_balance, :closing_balance

    def initialize(transactions, opening_balance, closing_balance)
      @transactions    = transactions
      @opening_balance = opening_balance
      @closing_balance = closing_balance
    end

  end
end
