require 'minitest/autorun'
require 'test_helper'
require 'volksbanker/cli'

class CliTest < MiniTest::Unit::TestCase

  def test_happy_path
    expected_stdout = read_fixture 'result.csv'
    expected_stderr = ''

    assert_output expected_stdout, expected_stderr do
      Volksbanker::Cli.run fixture('transactions.csv')
    end
  end

  def test_skips_non_euro_line_items
    out, err = capture_io do
      Volksbanker::Cli.run fixture('transactions-with-non-euro.csv')
    end

    refute_match %r{30/07/2012}m, out
    assert_match /Skipping/, err
  end

end
