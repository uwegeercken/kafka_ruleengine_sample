# kafka_ruleengine_sample

Contains everything required to run a sample process to read data from a kafka topic,
process it using the ruleengine and output the data to a different topic.

The business logic (rules) will do the following:

* check if the person travelling is below the age of 3. If so a 100% discount is applied.
* check if the person is 50 or older and if so apply a 25% discount
* Data from the "destination_region" field is translated to the appropriate three letter region code (lookup)
* Calculate the discounted price

The rules are in the travel_discount_dev.zip file and are created using the Business Rules
Maintenance Web UI.
    
Look at the kafka_ruleengine.properties file for the configuration and adjust as
appropriate.

Import the data from the discount_sample.json file into the kafka topic "travel_discount"
or whatever you configured in the properties file:

    bin/kafka-console-producer.sh --broker-list localhost:9092 --topic travel_discount < discount_sample.json

There is a shell script "run_kafka_ruleengine.sh". Make sure it is executable and run it.

The processed data will go to a topic named "travel_discount_ruleengine" or whatever you
configured.

Look at the processed data:

    bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic travel_discount --from-beginning


Uwe Geercken - 2018-05-31


