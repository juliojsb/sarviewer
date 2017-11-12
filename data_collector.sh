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
# Dependencies  :sysstat,gnuplot
# Usage         :1)Give executable permissions to script -> chmod +x data_collector.sh
#                2)Execute script -> ./data_collector.sh
# License       :GPLv3
#

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
}

how_to_use(){
	echo "This script works without parameters. Just give execution permissions and launch with -> ./data_collector.sh"
}

# ======================
# MAIN
# ======================

if [ $# -ne 0 ];then
	how_to_use
else
	echo -n "Please specify the number of samples to take-> "
	read number_of_samples
	echo -n "Please specify the sample interval (take sample every X seconds)-> "
	read sample_interval

	# Begin collecting data with sar
	sar_collectors

	total_time=$(( $sample_interval * $number_of_samples))
	echo "Total time to collect data -> ${total_time} seconds"
	echo ">>>Collecting data..."
	echo ">>>Please wait until data collection is completed..."
	echo "You can abort this script with Ctrl+C, but have in mind the data will stop being collected when you cancel it."
	echo "You will also need to manually launch script plotter.sh to generate the graphs."
	sleep $total_time

	# Added additional sleep of 5 seconds to avoid "warning: Skipping data file with no valid points"
	sleep 5

	# Call plotter.sh to generate the graphs
	./plotter.sh
fi
