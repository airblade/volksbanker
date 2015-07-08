require 'volksbanker/statement'
require 'volksbanker/balance'
require 'volksbanker/transaction'

module Volksbanker

  class VolksbankFileReader
    def initialize(file)
      @file = file
      read
    end

    def statement
      Statement.new @line_items, @opening_balance, @closing_balance
    end

    private

    def read
      # Layout of file:
      #   Header information including blank lines.
      #   Subsequent non-blank lines: transactions.
      #   Blank line
      #   Opening balance
      #   Closing balance

      @line_items = []
      header = true

      data = File.open(@file,'r:iso-8859-1:utf-8') { |f| f.read }
      data = clean_line_breaks data
      data.each_line do |line|
        # skip header
        if last_line_of_header? line
          header = false
          next
        end
        next if header

        line.chomp!

        if opening_balance? line
          @opening_balance = Balance.parse line
        elsif closing_balance? line
          @closing_balance = Balance.parse line
        else
          unless line.empty?
            @line_items << Transaction.parse(line) rescue $stderr.puts "Problem with #{line}: #{$!}"
          end
        end
      end
    end

    def last_line_of_header?(str)
      str =~ /^"Buchungstag";"Valuta";/
    end

    def opening_balance?(str)
      str =~ /;"Anfangssaldo";/
    end

    def closing_balance?(str)
      str =~ /;"Endsaldo";/
    end

    def clean_line_breaks(str)
      # Format uses CRLF (\r\n) for line breaks and LF (\n) for intra-line breaks (whatever
      # they are).
      # There must be a neat Ruby way to do this...
      unixify_line_breaks remove_intra_line_breaks(str)
    end

    def remove_intra_line_breaks(str)
      # Replace LF, but not CRLF, with space.
      str.
        gsub(/^\n/, ' ').          # a line beginning with a LF character
        gsub(/([^\r])\n/, '\1 ').  # a non-CR character followed by a LF character
        squeeze(' ')
    end

    def unixify_line_breaks(str)
      # Replace CRLF with LF.
      str.gsub "\r\n", "\n"
    end
  end

end
