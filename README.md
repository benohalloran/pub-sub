PubSub In Thrift/Ruby

[![Build Status](https://travis-ci.org/benohalloran/pub-sub.svg?branch=master)](https://travis-ci.org/benohalloran/pub-sub)

# Setup
This project requires [Thrift](https://thrift.apache.org/) to be installed with ruby support.

To generate the require Ruby bindings, run `thrift --gen rb pubsub.thrift` this will create a subdirectory gen-rb that contains the Ruby bindings to the Thrift library.

# Use
The Broker service is implemented in the `broker.rb`. This service manages the subscription list. A simple consumer service is implemented in `consumer.rb`; this simple consumer just prints out messages that it receives. Both of these scripts when run starts the server (requiring them allows use of the classes without starting the server). The consumer defaults to port 9091 and the broker defaults to port 9090; these can be changed by giving a port at the command line, eg `ruby consumer.rb <port number>`.

Interactive use is permitted through the interactive.rb. Before running, a consumer server and a broker server must be running. The format to specify these is:<br>`ruby interactive.rb <broker_host> <broker_port> <consumer_host> <consumer_port>`. These values default match to localhost and the default broker/consumer ports above so running all three scripts with no command line arguments is a valid set up.

Interactive use provides the 3 main functionalities of the Pub/Sub: un/subscribe a consumer to a particular topic and publish a message to all subscribed consumers of a topic. An additional debug method (info) will dump the current subscription data to stdout. The interactive broker is killed at EOF. To simplify the interactive use, the interactive broker will only allow topics that do not contain a space; the backend services do not have this limitation.

The format of the commands are: subscribe: `subscribe <topic>`<br>unsubscribe: `unsubscribe <topic>`<br>publish: `publish <topic to publish> <message to publish>` info: `info`

# Quick test
To quickly check the system is working correctly, run `ruby test.rb`. This script runs the interactive script using every file located in tests/ as input.
