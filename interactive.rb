#!/usr/bin/env ruby

$LOAD_PATH.push('./gen-rb')
require 'thrift'
require 'pub_sub_consumer'
require 'pub_sub_broker'
require 'pubsub_types'

broker_host = ARGV[0] || 'localhost'
broker_port = (ARGV[1] || 9090).to_i
client_host = ARGV[2] || 'localhost'
client_port = (ARGV[3] || 9091).to_i

transport = Thrift::BufferedTransport.new(Thrift::Socket.new(broker_host, broker_port))
protocol = Thrift::BinaryProtocol.new(transport)
broker = Concord::PubSub::PubSubBroker::Client.new(protocol)

puts "Broker is #{broker_host}:#{broker_port}"
puts "Client is #{client_host}:#{client_port}"

transport.open
STDIN.each_line do |line|
  case line
  when /subscribe\s(?<topic>.*)/
    broker.subscribe $~[:topic], client_host, client_port
  when /unsubscribe\s(?<topic>.*)/
    broker.unsubscribe $~[:topic], client_host, client_port
  when /publish\s(?<topic>\w*)\s(?<msg>.*)/
    puts "topic=#{$~[:topic]} msg = #{$~[:msg]}"
    broker.publish $~[:topic], $~[:msg]
  when /info.*/
    broker.info
  else
    STDERR.puts "Invalid input #{line}"
  end
end
transport.close
