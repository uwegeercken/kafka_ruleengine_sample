#!/bin/bash
# script to run the KafkaRuleEngine java program
#
# the program will read the properties from the given properties files.
# Then messages from the kafka source topic are read, processed using
# the ruleengine project file and the result will be output to a kafka
# target topic. Additonally a topic may be specified to output the
# detailed results of the ruleengine execution.
#
# last update: uwe.geercken@web.de - 2018-06-16


# path and name of the general properties file to use. if undefined use the default name
properties_file="${1:-kafka_ruleengine.properties}"

# path and name of the kafka consumer properties file to use. if undefined use the default name
properties_file_kafka_consumer="${2:-kafka_consumer.properties}"

# path and name of the kafka producer properties file to use. if undefined use the default name
properties_file_kafka_producer="${3:-kafka_producer.properties}"

# path and name of ruleengine project zip file. if undefined use the default name
ruleengine_project_file="${4:-travel_discount_dev.zip}"

# run the kafka ruleengine program
java -cp .:"lib/*" com.datamelt.kafka.ruleengine.KafkaRuleEngine "${properties_file}" "${properties_file_kafka_consumer}" "${properties_file_kafka_producer}" "${ruleengine_project_file}"

