# kafka_ruleengine_sample

Contains everything required to run a sample process to read data from a kafka topic,
process it using the ruleengine and output the data to a different topic.

The business logic (rules) will do the following:

* check if the person travelling is below the age of 3. If so a 100% discount is applied.
* check if the person is 50 or older and if so apply a 25% discount
* Data from the "destination_region" field is translated to the appropriate three letter region code (lookup)
* Calculate the discounted price

The rules are in the travel_discount_dev.zip file and are created using the Business Rules
Maintenance Web UI. Check: https://github.com/uwegeercken/rule_maintenance_war for more information.
    
Look at the kafka_ruleengine.properties file for the configuration and adjust as
appropriate.

In the properties file there are three output topics that can be defined:
* output topic
* output topic for failed messages
* output topic for logging

If no topic for failed messages is defined, then all messages that come in, go to the output topic. If a topic
for failed messages is defined then passed messages go to the output topic and failed messages go to the topic
for failed messages.

If a topic for logging is defined then all detailed results of executing the ruleengine will go to the logging
topic. For each input message and rule one output message to the logging topic is generated. So if you have
10 input messages and 5 rules, then 50 messages are generated to the logging topic.

There are two modes possible with the ruleengine:
1 Update only mode: Define the output topic, don't define the failed topic. All input messages will be processed.
The rule logic will define which records are updated (using actions) and which not. And then all messages are
sent to the output topic.

2 Check data mode: Define the output topic and define the failed topic. All input messages will be processed.
A single message will need to pass all rulegroups. If it does, it is sent to the output topic only, if not
is is sent to the failed topic only. So this mode checks if all logic (based on the rulegroups) that you defined
is correct for each record. See also the note below.

In any case you can define or not define a topic for logging where the detailed results of the execution of the
ruleengine are sent. I gives detailed information on why a certain message failed or not. And is helpful for
identifying problems in the data and for debugging.

Note: One or multiple rules are composed in a rulegroup. This way you can have rules that pass and rules that fail
but the rulegroup as such passes. E.g. if you have two rules: one checks if the age is smaller than 50 and the
other checks if the age is greater or equal to 50. The rules are connected using an "or" operator. If we have now a
person at the age of 40, the first rule will pass and the other one will fail. But the rulegroup in which both rules
are collected, will pass.

Import the data from the discount_sample.json file into the kafka topic "travel_discount"
or whatever you configured in the properties file:

    bin/kafka-console-producer.sh --broker-list localhost:9092 --topic travel_discount < discount_sample.json

There is a shell script "run_kafka_ruleengine.sh". Make sure it is executable and run it. The program will run,
read the messages from the input topic and output them according to the configuration.

The processed data will go to a topic named "travel_discount_ruleengine" or whatever you
configured.

Look at the processed data:

    bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic travel_discount --from-beginning


Please send your feedback and help to enhance the tool.

    Copyright (C) 2006-2018  Uwe Geercken


 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.


uwe geercken
uwe.geercken@web.de

last update: 2018-06-02



