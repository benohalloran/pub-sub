// feel free to add a `namespace` annotation here for your chosen language
namespace py concord.pubsub
namespace rb Concord.PubSub
namespace cpp concord.pubsub
namespace java concord.pubsub

service PubSubBroker {
  // subscribe / unsubscribe a new consumer to a topic
  void subscribe(1:string topic, 2:string host, 3:i32 port);
  void unsubscribe(1:string topic, 2:string host, 3:i32 port);

  // publish a message to a topic
  void publish(1:string topic, 2:string message);
}

service PubSubConsumer {
  // callback for receiving a message published ona  topic to which this
  // consumer is subscribed
  void receive(1:string topic, 2:string message);
}
