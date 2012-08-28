class MiniTest::Unit::TestCase

  # Returns full path to fixture file.
  def fixture(filename)
    File.expand_path "../fixtures/#{filename}", __FILE__
  end

  # Returns contents of fixture file.
  def read_fixture(filename)
    File.open(fixture filename) { |f| f.read }
  end

end
