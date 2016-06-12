# sarviewer

This repository is intended to give a simple way to measure resources usage (CPU, RAM...) in a machine. It uses sar to retrieve data and gnuplot to generate graphs from it.

Useful to retrieve and analyze data during stress tests.

#### Usage

* Install sysstat and gnuplot in your system using your

        # Debian & based
        apt-get install sysstat gnuplot
        # RHEL & based
        yum install sysstat gnuplot

* Clone this repo

* Launch the data_collector.sh script. Specify the number of samples and interval to take each sample. Notice that whenever you want you can cancel the collector with Ctrl+C, interrumpting the collection of data. If it is cancelled you will need to launch the script plotter.sh manually.

* Once the script has finished the data collection or you have cancelled it (and subsequently launched plotter.sh) you can analyze the resource usage in the graphs that have been generated in graphs/ folder of this repo.

#### Samples

Some samples of graphs generated.

* RAM
 
* CPU
 
* Load Average

* Processes
