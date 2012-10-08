# Volksbank format line by line:
#
# Header information including blank lines.
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

      header = true
      data.each_line do |line|
        # skip header
        if line =~ /^"Buchungstag";"Valuta";/  # final line of header
          header = false
          next
        end
        next if header

        line.chomp!
        break if line.empty?  # stop before footer

        yield VolksbankLineItem.new_from_csv line rescue $stderr.puts "Problem with #{line}: #{$!}"
      end
    end

    private

    def clean_line_breaks(str)
      # Format uses CRLF (\r\n) for line breaks and LF (\n) for intra-line breaks (whatever
      # they are).
      # There must be a neat Ruby way to do this...
      remove_inter_line_breaks remove_intra_line_breaks(str)
    end

    def remove_intra_line_breaks(str)
      # Replace bare new lines (\n not preceded by \r) with space.
      str.gsub /([^\r])\n/, '\1 '
    end

    def remove_inter_line_breaks(str)
      # Replace CRLF with LF.
      str.gsub "\r\n", "\n"
    end
  end

end
