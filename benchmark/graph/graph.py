import sys
from matplotlib import pyplot as plt
from matplotlib import colors
import json
import argparse
import os

SAVE_PATH="./images"

class Results:
    def __init__(self):
        self.li = []
        
    def parse(self, json_obj):
        s = json_obj["ALL STATS"]["Sets"]
        throughput = s.get("Ops/sec", 0)
        latency = s.get("Latency",0)
        
        c = json_obj["configuration"]
        requests = c.get("requests", 0)
        port = c.get("port",0)
        self.li.append(Result(throughput, latency, requests, port))
            
    def throughput_list(self):
        values = []
        names = []
        for l in self.li:
            names.append(l.name)
            values.append(l.throughput)            
        return names, values
        
    def latency_list(self):
        values = []
        names = []
        for l in self.li:
            names.append(l.name)
            values.append(l.latency)
        return names, values

    def get_list_by(self, key, by):
        x = []
        y = []
        for idx,l in enumerate(self.li):
            x.append(l.get(by, idx))
            y.append(l.get(key, idx))
        return x,y
        
class Result:
    def __init__(self, throughput, latency, requests, port):
        self.throughput = throughput
        self.latency = latency
        self.requests = requests
        self.name = ""
        if port == 6379:
            self.name = "redis"
        if port == 6380:
            self.name = "df"
        if port == 11211:
            self.name = "memcached"
    def get(self, key, default):
        return self.__dict__.get(key, default)
            


def graph(ax, x, y, title, y_title):
    # fig, ax = plt.subplots()
    ax.set_title(title)
    ax.set_ylabel(y_title)
    rect = ax.bar(x, y)
    c = list(colors.TABLEAU_COLORS.values())
    for i, r in enumerate(rect):
        r.set_color(c[i])


def get_title(file_name, default):
    if file_name is not None:
        return os.path.splitext(os.path.basename(file_name))[0]
    else:
        return default

parser = argparse.ArgumentParser()
parser.add_argument("-o")
parser.add_argument("-f", nargs='+', required=True)
args = parser.parse_args()

files = args.f
save_file = args.o

results =  Results()
for file_name in files:
    f = open(file_name, 'r')
    json_load = json.load(f)    
    results.parse(json_load)

fig = plt.figure()
ax1 = fig.add_subplot(1, 2, 1)
ax2 = fig.add_subplot(1, 2, 2)

title = get_title(save_file, "graph")
plt.suptitle(title,fontsize=15)

x, y = results.get_list_by("throughput", "name")
# x, y = results.get_list_by("throughput", None)
graph(ax1, x, y, "Ops/sec", "Ops/sec")

x, y = results.get_list_by("latency", "name")
# x, y = results.get_list_by("Latency", None)
graph(ax2, x, y, "Latency", "Latency")

if save_file is None:
    plt.show()
else:
    f = os.path.join(SAVE_PATH, save_file)
    print("save ", f)
    plt.savefig(f)

