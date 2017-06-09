echo " " >> resultsAllConfigs.txt
echo " " >> resultsAllConfigs.txt
echo "##########################################################################################################################" >> resultsAllConfigs.txt
echo "##########################################################################################################################" >> resultsAllConfigs.txt
date >> resultsAllConfigs.txt
echo " " >> resultsAllConfigs.txt

mainDir=`pwd`
configTemplate="openSMILEconfig="


cp local_config.sh local_config_save.sh

configDir="/home/ze/workspace/git/PF/Lab4/Part1/Ruben/opensmile-2.3.0/config"

# declare -a arr=("IS10_paraling.conf" "element2" "element3")

# for CONFIG in "${arr[@]}"
# for CONFIG in "$configDir"/*.conf
for CONFIG in `find $configDir -name \*.conf -print`
do
	# echo "$CONFIG"
	echo "$configTemplate$CONFIG" > local_config.sh

	cat local_config_template.sh >> local_config.sh

	echo " " >> resultsAllConfigs.txt
	echo "##################################################################" >> resultsAllConfigs.txt
	echo "$CONFIG" >> resultsAllConfigs.txt
	echo " " >>resultsAllConfigs.txt
	./LAB4_BASELINE.sh >> resultsAllConfigs.txt
	
done

mv local_config_save.sh local_config.sh