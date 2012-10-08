require 'volksbanker/volksbank_file_reader'
require 'volksbanker/amex_line_item'

module Volksbanker

  class Cli
    def self.run(volksbank_file)
      reader = VolksbankFileReader.new volksbank_file
      reader.each_line_item do |vli|
        unless vli.currency == 'EUR'
          $stderr.puts "Skipping non-EUR currency line item: #{vli.inspect}"
          next
        end
        ali = AmexLineItem.new vli.posting_date, vli.value, description_for(vli)
        CSV { |out| out << [ali.date, ali.amount, ali.description] }
      end
    end

    private

    def self.description_for(volksbank_line_item)
      desc = volksbank_line_item.description
      desc += " (#{volksbank_line_item.recipient_or_payer})" unless volksbank_line_item.recipient_or_payer.nil?
      desc
    end
  end

end
