#!/usr/bin/env ruby

$LOAD_PATH.push('./gen-rb')
require 'thrift'
require 'pub_sub_consumer'
require 'pub_sub_broker'
require 'pubsub_types'

# A very simple Consumer that just dumps the output to STDOUT
class SimpleConsumer
  def initialize
    @start_time = Time.now
    # When this consumer shutsdown (is GCd) it prints how long it recieved messages
    ObjectSpace.define_finalizer(self, proc {
      puts "Client ran for #{Time.now - @start_time}"
    })
  end

  def receive(topic, msg)
    puts "Consumer received #{msg} on topic #{topic}"
  end
end
# Only execute this script if this is the main file that's being run,
# eg you ran `ruby broker.rb` or `./broker.rb`
# This allows the class to be used as a require without starting the server
if __FILE__ == $PROGRAM_NAME
  port = (ARGV[0] || 9091).to_i
  handler = SimpleConsumer.new
  processor = Concord::PubSub::PubSubConsumer::Processor.new(handler)
  transport = Thrift::ServerSocket.new(port)
  transportFactory = Thrift::BufferedTransportFactory.new
  server = Thrift::SimpleServer.new(processor, transport, transportFactory)
  puts "Starting client server on port #{port}"
  server.serve
end
