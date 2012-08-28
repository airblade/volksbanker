# Volksbank format line by line:
#
# Lines 1-13: header
# Subsequent non-blank lines: semi-colon separated values
#   posting date
#   value date
#   payer/payee
#   recipient/payer
#   account no.
#   sortcode
#   description
#   currency
#   amount
#   credit (H) /debit (S)
# Blank line
# Footer (opening and closing balances)

require 'volksbanker/volksbank_line_item'
require 'volksbanker/amex_line_item'

module Volksbanker

  class VolksbankFileReader
    def initialize(file)
      @file = file
    end

    # Yields each transaction line item to the block.
    # I.e. skips the header and footer information.
    def each_line_item(&block)
      data = File.open(@file,'r:iso-8859-1:utf-8') { |f| f.read }
      data = clean_line_breaks data

      line_number = 0
      data.each_line do |line|
        line_number += 1           # 1-based line numbering
        next if line_number <= 13  # skip header
        line.chomp!
        break if line.empty?       # skip footer

        yield VolksbankLineItem.new_from_csv line
      end
    end

    private

    def clean_line_breaks(str)
      # Format uses \r\n for line breaks between inter-line breaks and \n for intra-line breaks.
      # There must be a neat Ruby way to do this...
      remove_inter_line_breaks remove_intra_line_breaks(str)
    end

    def remove_intra_line_breaks(str)
      str.gsub /([^\r])\n/, '\1 '
    end

    def remove_inter_line_breaks(str)
      str.gsub "\r\n", "\n"
    end
  end

end