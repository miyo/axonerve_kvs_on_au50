import sys
import time
import socket
import netifaces
import binascii

from raw_axonerve_util import Axonerve

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("{} ethernet-dev-name #.queries".format(sys.argv[0]))
        sys.exit(0)
    dev = sys.argv[1]
    num = int(sys.argv[2])

    axonerve = Axonerve(dev)
    
    kv = []
    k = []
    for i in range(num):
        kk = b''
        kk += b'\x02\x02\x03\x04\x05\x06\x07\x08' # key
        kk += b'\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10'
        kk += b'\x11\x12\x13\x14\x15\x16\x17\x18'
        kk += b'\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20'
        kk += bytearray([i,i,i,i])
        vv = bytearray([i,i,i,i])
        k.append(kk)
        kv.append([kk,vv])

    print("write")
    ret = axonerve.write(kv)
    for r in ret:
        print(r)
