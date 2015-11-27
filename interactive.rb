#!/usr/bin/env ruby

$LOAD_PATH.push('./gen-rb')
require 'thrift'
require 'pub_sub_consumer'
require 'pub_sub_broker'
require 'pubsub_types'
# Set up hosts & ports
broker_host = ARGV[0] || 'localhost'
broker_port = (ARGV[1] || 9090).to_i
# the client information belongs to the consumer. These are used to fill in values to subscribe/unsubscribe/publish
client_host = ARGV[2] || 'localhost'
client_port = (ARGV[3] || 9091).to_i
# Interactive talks to the broker. The broker talks to the client
transport = Thrift::BufferedTransport.new(Thrift::Socket.new(broker_host, broker_port))
protocol = Thrift::BinaryProtocol.new(transport)
broker = Concord::PubSub::PubSubBroker::Client.new(protocol)

puts "Broker is #{broker_host}:#{broker_port}"
puts "Client is #{client_host}:#{client_port}"

STDIN.each_line do |line|
  transport.open
  puts line unless STDIN.tty?
  case line
  when /\Asubscribe\s(?<topic>.*)$/
    broker.subscribe $~[:topic], client_host, client_port
  when /\Aunsubscribe\s(?<topic>.*)$/
    broker.unsubscribe $~[:topic], client_host, client_port
  when /\Apublish\s(?<topic>\w*)\s(?<msg>.*)$/
    broker.publish $~[:topic], $~[:msg]
  when /\Ainfo.*$/
    broker.info
  else
    STDERR.puts "Invalid input #{line}"
  end
  transport.close
end
