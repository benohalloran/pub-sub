#!/usr/bin/env ruby

$LOAD_PATH.push('./gen-rb')
require 'thrift'
require 'pub_sub_consumer'
require 'pub_sub_broker'
require 'pubsub_types'

#A very simple Consumer that just dumps the output to STDOUT
class SimpleConsumer
  def initialize()
    @start_time = Time.now
    ObjectSpace.define_finalizer(self, Proc.new {
      puts "Client ran for #{Time.now - @start_time}"
    })
  end

  def receive(topic, msg)
    puts "Consumer recieved #{msg} on topic #{topic}"
  end
end
#Only execute this script if this is the main file that's being run,
#eg you ran `ruby broker.rb` or `./broker.rb`
if __FILE__ == $0
  port = (ARGV[0] || 9091).to_i
  handler = SimpleConsumer.new()
  processor = Concord::PubSub::PubSubConsumer::Processor.new(handler)
  transport = Thrift::ServerSocket.new(port)
  transportFactory = Thrift::BufferedTransportFactory.new()
  server = Thrift::SimpleServer.new(processor, transport, transportFactory)
  puts "Starting client server on port #{port}"
  server.serve
end
