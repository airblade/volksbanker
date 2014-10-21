require 'minitest/autorun'
require 'test_helper'
require 'volksbanker/cli'

class CliTest < MiniTest::Unit::TestCase

  def test_happy_path
    expected_stdout = read_fixture 'result.stdout.csv'
    expected_stderr = read_fixture 'result.stderr.csv'

    assert_output expected_stdout, expected_stderr do
      Volksbanker::Cli.run fixture('transactions.csv')
    end
  end

  def test_handles_line_feed_shenanigans
    out, err = capture_io do
      Volksbanker::Cli.run fixture('newlines.csv')
    end

    assert_equal read_fixture('newlines.stderr.csv'), err
  end

end
