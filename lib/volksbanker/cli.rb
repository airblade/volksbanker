require 'volksbanker/statement'
require 'volksbanker/volksbank_file_reader'
require 'volksbanker/amex_line_item'

module Volksbanker

  class Cli
    def self.run(volksbank_file)
      statement = VolksbankFileReader.new(volksbank_file).statement
      statement.transactions.each do |transaction|
        ali = AmexLineItem.new transaction.posting_date, transaction.amount, transaction.description_with_counterparty
        CSV { |out| out << [ali.date, ali.amount, ali.description] }
      end
      $stderr.puts "opening balance: #{statement.opening_balance}"
      $stderr.puts "closing balance: #{statement.closing_balance}"
    end
  end

end
