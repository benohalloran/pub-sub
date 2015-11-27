PubSub In Thrift/Ruby

#Setup  


This project requires [Thrift](https://thrift.apache.org/) to be installed with ruby support.

To generate the require Ruby bindings, run `thrift --gen rb pubsub.thrift` this will create a subdirectory gen-rb that contains the Ruby bindings to the Thrift library.

#Use  
The Broker service is implemented in the `broker.rb`. This service manages the subscription list. A simple consumer service is implemented in `consumer.rb`; this simple consumer just prints out messages that it receives. Both of these scripts when run starts the server (requiring them allows use of the classes without starting the server). The consumer defaults to port 9091 and the broker defaults to port 9090; these can be changed by a specifing a port at the command line, eg `ruby consumer.rb <port number>`.


Interactive use is permitted through the interactive.rb. Before running, a consumer server and a broker server must be running. The format to specify these is:  
`ruby interactive.rb <broker_host> <broker_port> <consumer_host> <consumer_port>`.
These values default match to localhost and the default broker/consumer ports above.


#Quick test

To quickly check the system is working correctly, run `ruby test.rb`. This script runs the interactive script using every file located in tests/ as input. 
