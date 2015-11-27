require 'test/unit'

def run_script(file)
  system "ruby interactive.rb < #{file} &> /dev/null"
  $?.success?
end
BrokerCmd = "ruby ./broker.rb &> /dev/null"
ClientCmd = "ruby ./client.rb &> /dev/null"

class CalcTests < Test::Unit::TestCase
  def setup
    @brokerpid = spawn(BrokerCmd)
    @clientpid = spawn(ClientCmd)
  end
  def teardown
    Process.kill("KILL", @brokerpid)
    Process.kill("KILL", @clientpid)
  end

  Dir["./tests/*"].each{|script|
    define_method("test_#{script}"){
      assert_equal true, run_script(script)
    }
  }
end
