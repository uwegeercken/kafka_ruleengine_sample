#!/bin/bash
# script to run the KafkaRuleEngine java program
#
# the program will read the properties from the given properties files.
# Then messages from the kafka source topic are read, processed using
# the ruleengine project file and the result will be output to a kafka
# target topic. Additonally a topic may be specified to output the
# detailed results of the ruleengine execution.
#
# mandatory: pass the path and name of the ruleengine project zip file as the first parameter
# optional:  pass the path and name of the ruleengine properties file as the second parameter. default is: same folder as script.
# optional:  pass the path and name of the kafka consumer properties file as the third parameter. default is: same folder as script.
# optional:  pass the path and name of the kafka producer properties file as the fourth parameter. default is: same folder as script.
#
# last update: uwe.geercken@web.de - 2019-05-04

# determine the script folder
script_folder=$(dirname "$(readlink -f "$BASH_SOURCE")")

# path and name of ruleengine project zip file.
ruleengine_project_file=$(readlink -f "${1}")

# path and name of the general properties file to use. if undefined use the default name
properties_file=$(readlink -f "${2:-${script_folder}/kafka_ruleengine.properties}")

# path and name of the kafka consumer properties file to use. if undefined use the default name
properties_file_kafka_consumer=$(readlink -f "${3:-${script_folder}/kafka_consumer.properties}")

# path and name of the kafka producer properties file to use. if undefined use the default name
properties_file_kafka_producer=$(readlink -f "${4:-${script_folder}/kafka_producer.properties}")

errorRuleEngineProjectFile=false
errorRuleEnginePropertiesFile=false
errorKafkaConsumerPropertiesFile=false
errorKafkaProducerPropertiesFile=false

if [ ! -f "${ruleengine_project_file}" ]
then
	errorRuleEngineProjectFile=true
	echo "error: file [${ruleengine_project_file}] not found."
fi

if [ ! -f "${properties_file}" ]
then
	errorRuleEnginePropertiesFile=true
	echo "error: file [${properties_file}] not found."
fi

if [ ! -f "${properties_file_kafka_consumer}" ]
then
	errorKafkaConsumerPropertiesFile=true
	echo "error: file [${properties_file_kafka_consumer}] not found."
fi

if [ ! -f "${properties_file_kafka_producer}" ]
then
	errorKafkaProducerPropertiesFile=true
	echo "error: file [${properties_file_kafka_producer}] not found."
fi

if [ ${errorRuleEngineProjectFile} == false ] && [ ${errorRuleEnginePropertiesFile} == false ] && [ ${errorKafkaConsumerPropertiesFile} == false ] && [ ${errorKafkaProducerPropertiesFile} == false ]  
then
	echo "running KafkaRuleEngine program..."

	# run the kafka ruleengine program
	java -cp "${script_folder}":"${script_folder}/lib/*" com.datamelt.kafka.ruleengine.KafkaRuleEngine "${properties_file}" "${properties_file_kafka_consumer}" "${properties_file_kafka_producer}" "${ruleengine_project_file}"
else
	echo "exiting program..."
fi

