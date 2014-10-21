require 'csv'

class VolksbankLineItem
  DATE_FORMAT = '%d.%m.%Y'

  attr_reader :posting_date, :value_date, :payer_or_payee, :recipient_or_payer,
              :account_number, :sort_code, :description, :currency,
              :value

  def initialize(posting_date, value_date, payer_or_payee, recipient_or_payer,
                account_number, sort_code, description, currency,
                amount, credit_or_debit)
    @posting_date       = parse_date posting_date
    @value_date         = parse_date value_date
    @payer_or_payee     = payer_or_payee
    @recipient_or_payer = recipient_or_payer
    @account_number     = account_number
    @sort_code          = sort_code

    @description        = description
    @currency           = currency
    # The opening and closing balance lines switch the currency and description fields.
    if %w[ Anfangssaldo Endsaldo ].include? currency
      @description = currency
      @currency = description
    end

    amt = parse_number amount
    @value = credit?(credit_or_debit) ? amt : (amt * -1)
  end

  def self.new_from_csv(line)
    CSV.parse(line, col_sep: ';') { |row| return new(*row) }
  end

  private

  def parse_date(str)
    Date.strptime str, DATE_FORMAT if str
  end

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

