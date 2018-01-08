#!/usr/bin/env python2
"""
Author        :Julio Sanz
Website       :www.elarraydejota.com
Email         :juliojosesb@gmail.com
Description   :Generate sockets graph from sockets.dat file
Dependencies  :Python 2.x, matplotlib
Usage         :python sockets.py
License       :GPLv3
"""

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt 
import csv
from datetime import datetime
import matplotlib.dates

# ======================
# VARIABLES
# ======================

# Aesthetic parameters
plt.rcParams.update({'font.size': 8})
plt.rcParams['lines.linewidth'] = 1.5
time_format = matplotlib.dates.DateFormatter('%H:%M:%S')
plt.gca().xaxis.set_major_formatter(time_format)
plt.gcf().autofmt_xdate()

# Time (column 0)
x = []
# Data arrays
t_tcp = []
t_tcp_use = []
t_udp_use = []
t_tcp_time_wait = []

# ======================
# FUNCTIONS
# ======================

def generate_graph():
    with open('../../data/sockets.dat', 'r') as csvfile:
        data_source = csv.reader(csvfile, delimiter=' ', skipinitialspace=True)
        for row in data_source:
            # [0] column is a time column
            # Convert to datetime data type
            a = datetime.strptime((row[0]),'%H:%M:%S')
            x.append((a))
            # The remaining columns contain data
            t_tcp.append(str((int(row[2]))+(int(row[6]))))
            t_tcp_use.append(row[2])
            t_udp_use.append(row[3])
            t_tcp_time_wait.append(row[6])
    
    # Plot lines
    plt.plot(x,t_tcp, label='Total TCP sockets', color='#ff9933', antialiased=True)
    plt.plot(x,t_tcp_use, label='TCP sockets in use', color='#66ccff', antialiased=True)
    plt.plot(x,t_udp_use, label='UDP sockets in use', color='#009933', antialiased=True)
    plt.plot(x,t_tcp_time_wait, label='TCP sockets in TIME WAIT state', color='#cc3300', antialiased=True)
    
    # Graph properties
    plt.xlabel('Time',fontstyle='italic')
    plt.ylabel('Number of sockets',fontstyle='italic')
    plt.title('Sockets')
    plt.grid(linewidth=0.4, antialiased=True)
    plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.20), ncol=2, fancybox=True, shadow=True)
    plt.autoscale(True)
    
    # Graph saved to PNG file
    plt.savefig('../../graphs/sockets.png', bbox_inches='tight')
    #plt.show()

# ======================
# MAIN
# ======================

if __name__ == '__main__':
    generate_graph()