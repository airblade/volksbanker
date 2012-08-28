require 'volksbanker/volksbank_file_reader'

module Volksbanker

  class Cli
    def self.run(volksbank_file)
      reader = VolksbankFileReader.new volksbank_file
      reader.each_line_item do |vli|
        unless vli.currency == 'EUR'
          $stderr.puts "Skipping non-EUR currency line item: #{vli.inspect}"
          next
        end
        ali = AmexLineItem.new vli.posting_date, vli.value, vli.description
        CSV { |out| out << [ali.date, ali.amount, ali.description] }
      end
    end
  end

end