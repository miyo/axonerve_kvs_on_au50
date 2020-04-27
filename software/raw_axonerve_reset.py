import sys
import time
import socket
import netifaces
import binascii

from raw_axonerve_util import Axonerve

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("usage: {} ethernet-dev-name".format(sys.argv[0]))
        sys.exit(0)
    dev = sys.argv[1]
    num = 16 if len(sys.argv) < 3 else int(sys.argv[2])
    axonerve = Axonerve(dev)
    
    axonerve.reset()

