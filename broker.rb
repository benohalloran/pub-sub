#!/usr/bin/env ruby

# The PubSubBroker service
$LOAD_PATH.push('./gen-rb')

require 'thrift'
require 'pub_sub_broker'
require 'pubsub_types'
require 'pub_sub_consumer'

# Basic Broker. Keeps track of the various subscribed consumers
class DataManager
  def initialize
    @data = {}
  end

  def subscribe(topic, host, port)
    puts "Broker subscribing #{host}:#{port} to #{topic}"
    @data[topic] = Set.new if @data[topic].nil?
    @data[topic] << { host: host, port: port }
  end

  def unsubscribe(topic, host, port)
    puts "Broker unsubscribing #{host}:#{port} from #{topic}"
    @data[topic].delete ({ host: host, port: port })
  end

  def publish(topic, msg)
    puts "Broker publishing '#{msg}' to '#{topic}' subscribers"
    if @data[topic].nil?
      puts "no subscribers for #{topic}. Discarding message #{msg}"
    else
      @data[topic].each do |subscriber|
        begin
          client_transport = Thrift::BufferedTransport.new(Thrift::Socket.new(subscriber[:host], subscriber[:port]))
          client = Concord::PubSub::PubSubConsumer::Client.new(
            Thrift::BinaryProtocol.new(client_transport))
          client_transport.open
          client.receive topic, msg
          client_transport.close

          puts "Broker sent #{msg} to #{subscriber}"
        rescue Exception => e
          STDERR.puts "Error writing to client #{e}"
        end
      end
    end
  end

  # Extra debug method that dumps out the current mapping of consumers and topics
  def info
    puts 'Current subscription map'
    puts @data
  end
end

# Only execute this script if this is the main file that's being run,
# eg you ran `ruby broker.rb` or `./broker.rb`
if __FILE__ == $PROGRAM_NAME
  socket = ARGV[0] || 9090
  handler = DataManager.new
  processor = Concord::PubSub::PubSubBroker::Processor.new(handler)
  transport = Thrift::ServerSocket.new(socket)
  transportFactory = Thrift::BufferedTransportFactory.new
  server = Thrift::SimpleServer.new(processor, transport, transportFactory)
  puts "Starting the broker server on port #{socket}"
  server.serve
  puts 'done.'
end
