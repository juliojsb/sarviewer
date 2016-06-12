#!/bin/bash
#
# Script        :plotter.sh
# Author        :Julio Sanz
# Website       :www.elarraydejota.com
# Email         :juliojosesb@gmail.com
# Description   :Script to generate gnuplot graphs in the folder graphs/ of this repository
# Dependencies  :sar,gnuplot
# Usage         :1)Give executable permissions to script -> chmod +x plotter.sh
#                2)Execute script -> ./plotter.sh
# License       :GPLv3
#

if [ $# -ne 0 ];then
	echo "This script doesn't accept parameters"
else
	cd plotters
	gnuplot loadaverage.gplot
	gnuplot cpu.gplot
	gnuplot ram.gplot
	gnuplot swap.gplot
	gnuplot iotransfer.gplot
	gnuplot proc.gplot
	gnuplot contextsw.gplot
fi
