require 'csv'

module Volksbanker

  # A transaction has the following fields on the Volksbank download:
  #
  #   posting date
  #   value date
  #   payer/payee
  #   recipient/payer
  #   account no.
  #   iban
  #   sortcode (BLZ)
  #   sortcode (BIC)
  #   description
  #   reference
  #   currency
  #   amount
  #   credit (H) / debit (S)
  class Transaction < Line
    attr_reader :posting_date, :value_date, :payer_or_payee, :recipient_or_payer,
                :account_number, :iban, :sort_code, :bic, :description, :reference, :currency,
                :amount

    def initialize(posting_date, value_date, payer_or_payee, recipient_or_payer,
                  account_number, iban, sort_code, bic, description, reference, currency,
                  amount, credit_or_debit)
      @posting_date       = parse_date posting_date
      @value_date         = parse_date value_date
      @payer_or_payee     = payer_or_payee
      @recipient_or_payer = recipient_or_payer
      @account_number     = account_number
      @iban               = iban
      @sort_code          = sort_code
      @bic                = bic
      @description        = description
      @reference          = reference
      @currency           = currency
      @amount             = parse_amount amount, credit_or_debit
    end

    def description_with_counterparty
      x = description
      x += " (#{recipient_or_payer})" unless recipient_or_payer.nil?
      x
    end
  end
end
