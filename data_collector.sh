#!/bin/bash
#
# Script        :data_collector.sh
# Author        :Julio Sanz
# Website       :www.elarraydejota.com
# Email         :juliojosesb@gmail.com
# Description   :Script to collect resources data using sar and put it in data/ folder of this repository.
#                Note this script is intended to collect data in real time (useful for stress tests) but
#                not to analyse the overall performance of a machine during a long time frame.
#                If you want to check historic data of the server, better use system_data_reader.sh script.
# Dependencies  :sysstat,gnuplot,mutt(optional)
# License       :GPLv3
#

# Initialize in sarviewer folder
cd $(dirname $0)

# ======================
# VARIABLES
# ======================

# Read sarviewer.properties file
. sarviewer.properties

# ======================
# FUNCTIONS
# ======================

sar_collectors(){
	# CPU
	sar -u $sample_interval $number_of_samples | grep -v -E "CPU|Average|^$" > data/cpu.dat &
	# RAM
	sar -r $sample_interval $number_of_samples | grep -v -E "[a-zA-Z]|^$" > data/ram.dat &
	# Swap
	sar -S $sample_interval $number_of_samples | grep -v -E "[a-zA-Z]|^$" > data/swap.dat &
	# Load average and tasks
	sar -q $sample_interval $number_of_samples | grep -v -E "[a-zA-Z]|^$" > data/loadaverage.dat &
	# IO transfer
	sar -b $sample_interval $number_of_samples | grep -v -E "[a-zA-Z]|^$" > data/iotransfer.dat &
	# Process/context switches
	sar -w $sample_interval $number_of_samples | grep -v -E "[a-zA-Z]|^$" > data/proc.dat &
	# Network Interface
	sar -n DEV $sample_interval $number_of_samples | grep $network_interface | grep -v "Average" > data/netinterface.dat &
	# Sockets
	sar -n SOCK $sample_interval $number_of_samples | grep -v -E "[a-zA-Z]|^$" > data/sockets.dat &

	total_time=$(($sample_interval * $number_of_samples))
	echo "Taking ${number_of_samples} samples with ${sample_interval} seconds interval"
	echo "Total time to collect all data: ${total_time} seconds"
	echo "----------------------------------"
	echo ">>> Collecting data"
	echo ">>> Please wait until data collection is completed"
	echo "----------------------------------"
	echo "- You can abort this script with Ctrl+C, but have in mind the data will stop being collected when you cancel it."
	echo "- You will also need to manually launch script plotter.sh to generate the graphs."
	sleep $total_time

	# Added additional sleep of 5 seconds to avoid "warning: Skipping data file with no valid points"
	echo "----------------------------------"
	echo ">>> Just 5 seconds more while processing all data"
	echo "----------------------------------"
	sleep 5
	echo "Done!"
}

howtouse(){
	cat <<-'EOF'

	This script can work with or without parameters.
	Without parameters, just execute it --> ./data_collector.sh
	If you use parameters, this is the correct format:
		-n [samples]                  number of samples to take
		-i [interval]                 interval (in seconds) between each sample
		-m [mail]                     mail address to send the graphs to
		-h                            help
	
	Examples:

		# Send by email statistics from 10 samples, taken each one every 1 second
		./data_collector.sh -n 10 -i 1 -m example@example.com
		# Generate statistics from 20 samples, taken each one very 2 seconds
		./data_collector.sh -n 20 -i 2 

	EOF
}

# ======================
# MAIN
# ======================

if [ "$#" -eq 0 ];then
	echo -n "Please specify the number of samples to take-> "
	read number_of_samples
	echo -n "Please specify the sample interval (take sample every X seconds)-> "
	read sample_interval

	# Begin collecting data with sar
	sar_collectors

	# Call plotter.sh to generate the graphs
	./plotter.sh

elif [ "$#" -ne 0 ];then
	while getopts ":n:i:m:h" opt; do
		case $opt in
			"n")
				number_of_samples="$OPTARG"
				;;
			"i")
				sample_interval="$OPTARG"
				;;
			"m")
				mail_to="$OPTARG"
				;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
				howtouse
				exit 1
				;;
			:)
				echo "Option -$OPTARG requires an argument." >&2
				howtouse
				exit 1
				;;
			"h"|*)
				howtouse
				exit 1
				;;
		esac
	done
	# Begin collecting data with sar
	sar_collectors

	# Call plotter.sh to generate the graphs
	./plotter.sh

	# Send mail if specified
	if [[ $mail_to ]];then
		echo "SARVIEWER - data_collector.sh sysstat statistics for $(hostname)" | mutt -a graphs/*.png -s "SARVIEWER - data_collector.sh sysstat statistics for $(hostname)" -- $mail_to
	fi
fi