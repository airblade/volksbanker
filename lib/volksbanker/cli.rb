require 'volksbanker/volksbank_file_reader'
require 'volksbanker/amex_line_item'

module Volksbanker

  class Cli
    def self.run(volksbank_file)
      reader = VolksbankFileReader.new volksbank_file
      reader.each_line_item do |vli|
        ali = AmexLineItem.new vli.posting_date, vli.value, description_for(vli)
        case ali.description
        when 'Anfangssaldo'; @opening_balance = pretty_amount(ali.amount, vli.currency)
        when 'Endsaldo';     @closing_balance = pretty_amount(ali.amount, vli.currency)
        else
          CSV { |out| out << [ali.date, ali.amount, ali.description] }
        end
      end
      $stderr.puts "opening balance: #{@opening_balance}"
      $stderr.puts "closing balance: #{@closing_balance}"
    end

    private

    def self.description_for(volksbank_line_item)
      desc = volksbank_line_item.description
      desc += " (#{volksbank_line_item.recipient_or_payer})" unless volksbank_line_item.recipient_or_payer.nil?
      desc
    end

    def self.pretty_amount(amount, currency)
      "#{'%.2f' % amount} #{currency}"
    end
  end

end
