$LOAD_PATH.push('../gen-rb')

require 'thrift'
require 'pub_sub_broker'
require 'pubsub_types'

# Basic Broker. Keeps track of the various subscribed consumers
class DataManager
  def initialize
    @data = {}
  end

  def subscribe(topic, host, port)
    @data[topic] = Set.new if @data[topic].nil?
    @data[topic] << { host: host, port: port }
  end

  def unsubscribe(topic, host, port)
    @data[topic].delete ({ host: host, port: port })
  end

  def publish(topic, msg)
    list = @data[topic]
    list.each do |subscriber|
      transport = Thrift::BufferedTransport.new(
        Thrift::Socket.new(subscriber[:host], subscriber[:port]))
      protocol = Thrift::BinaryProtocol.new(transport)
      # build the client to actually recieve the data
      client = Concord::PubSub::PubSubConsumer::Client(protocol)
      transport.open
      client.recieve topic, msg
      transport.close
      puts "Broker Sent #{msg} to #{subscriber}"
    end
  end

  def print
    puts @data
  end
end

# Very simple script to run to make sure that subscribe/unsubscribe works.
# Only runs if this is the main file, ie running `ruby data_manger.rb`
if __FILE__ == $PROGRAM_NAME
  manager = DataManager.new
  manager.subscribe('cat', 'localhost', 9090)
  manager.print
  manager.unsubscribe('cat', 'localhost', 9090)
  manager.print
end
