import subprocess
from subprocess import PIPE
import math
import sys
import re

def convert_size(size):
    units = ("B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB")
    i = math.floor(math.log(size, 1024)) if size > 0 else 0
    size = round(size / 1024 ** i, 2)

    return f"{size} {units[i]}"

def to_int_or(v, default = 0):
    try:
        return int(v)
    except:
        print("to_int_or error ", v)
        return default
    
def is_number_only(v):
    repatter = re.compile("^\d+$")
    result = repatter.search(v)
    return result is not None

class RedisCLI():
    def __init__(self, host, port):
        self.host = host
        self.port = port
                
    def __redis_cli_run(self, cmd):
        __cmd = "redis-cli -h {} -p {} {}".format(self.host, self.port, cmd)
        proc = subprocess.run(__cmd, shell=True, stdout=PIPE, stderr=PIPE, text=True)
        return proc.stdout

    def ping(self):
        result = self.__redis_cli_run("PING")
        print(result)

    def check_used_memory(self):
        cmd = "info memory | grep used_memory_overhead"
        result = self.__redis_cli_run(cmd)
        mem = int(result.split(":")[1])
        return mem
    
    def check_used_memory_human(self):
        cmd = "info memory | grep used_memory_human"
        result = self.__redis_cli_run(cmd)
        mem = int(result.split(":")[1])
        return mem
    
    def info_memory(self):
        cmd = "info memory"
        result = self.__redis_cli_run(cmd)
        d = {}
        for v in result.split("\n"):
            s = v.split(":")
            d[s[0]] = s[1] if len(s) > 1 else ""
        return d
    

    def debug_write(self, req_num):
        print("add... {}".format(req_num))
        result = self.__redis_cli_run("debug populate {}".format(req_num))

    def run(self, req_num, key):
        before = self.info_memory().get(key, 0)

        self.debug_write(req_num)
        after = self.info_memory().get(key, 0)
        return before, after 
    
def debug_print(type_name, before, after):
    print(type_name)
    print("before :", before)
    print("after :", after)
    if is_number_only(before) and is_number_only(after):
        d = int(after) - int(before)
        print("diff... {}".format(convert_size(d)))    
    print("------")


def diff(req_num, key):
    cli = RedisCLI("localhost", 6379)
    before, after = cli.run(req_num, key)
    debug_print("redis... {}".format(key), before, after)
    
    cli = RedisCLI("localhost", 6380)
    before, after = cli.run(req_num, key)
    debug_print("df... {}".format(key), before, after)


def main():
    if len(sys.argv) != 2:
        print("python check_used_memory.py {request_num}")
        print("request_num is required")
        sys.exit(1)

    req_num = sys.argv[-1]

    diff(req_num, "used_memory")
    diff(req_num, "used_memory_human")
    


if __name__ == "__main__":
    main()
