import sys
import time
import socket
import netifaces
import binascii

class Axonerve:
    

    def __init__(self, dev, debug=False):
        self.dev = dev
        self.debug = debug
        mac_addr_str = netifaces.ifaddresses(dev)[netifaces.AF_LINK][0]['addr']
        self.dest_addr  = b'\x00\x01\x02\x03\x04\x05' # destination address
        self.src_addr   = bytearray([int(x, 16) for x in mac_addr_str.split(':')])
        self.frame_type = b'\x34\x34' # frame type
        self.connect()

    def __del__(self):
        self.disconnect()

    def connect(self):
        ETH_P_ALL = 3
        self.sock = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(ETH_P_ALL))
        self.sock.bind((self.dev, 0))

    def disconnect(self):
        self.sock.close()

    def _sendrecv(self, message):
        self.sock.sendall(self.dest_addr + self.src_addr + self.frame_type + message)
        recv_data = self.sock.recv(9000)
        if self.debug:
            print("recv_len=", len(recv_data))
        return recv_data

    def reset(self):
        message = b''
        message += b'\x00\x01\x00\x00' # command length
        message += b'\x00\x00\x00\x00\x00\x00\x00\x00'
        message += b'\x00\x00\x00\x00\x00\x00\x00\x00'
        message += b'\x00\x00\x00\x00\x00\x00\x00\x00'
        message += b'\x00\x00\x00\x00\x00\x00\x00\x00'
        message += b'\x00\x00\x00\x00'
        message += b'\x00\x00\x00\x00' # value
        message += b'\x00\x00\x00\x00' # addr
        message += b'\x00\x00\x00\x00\x00\x00\x00\x00' # mask
        message += b'\x00\x00\x00\x00' # pri
        message += b'\x00\x00\x00\x10' # reset command
        rdata = self._sendrecv(message)
        if self.debug:
            print('dest', binascii.hexlify(rdata[:6]))
            print('src', binascii.hexlify(rdata[6:6+6]))
            print('header', binascii.hexlify(rdata[6+6:6+6+2]))
        
    def write(self, key_values):
        num = len(key_values)
        if(num > 128):
            return []
        command = bytearray([0, num, 0, 0])
        message = b''
        for kv in key_values:
            message += command
            message += kv[0]
            message += kv[1]
            message += b'\x00\x00\x00\x00' # addr
            message += b'\x00\x00\x00\x00\x00\x00\x00\x00' # mask
            message += b'\x00\x00\x00\x00' # pri
            message += b'\x00\x00\x00\x02' # write command
        rdata = self._sendrecv(message)
        addrs = []
        if self.debug:
            print('dest', binascii.hexlify(rdata[:6]))
            print('src', binascii.hexlify(rdata[6:6+6]))
            print('header', binascii.hexlify(rdata[6+6:6+6+2]))
        for i in range(num):
            offset = 14+(i*64)
            addrs.append([rdata[offset:offset+64][44:48], rdata[offset:offset+64][60:64]])
            if self.debug:
                print(binascii.hexlify(rdata[offset:offset+64]))
        return addrs
    
    def search(self, keys):
        num = len(keys)
        if(num > 128):
            return []
        command = bytearray([0, num, 0, 0])
        message = b''
        for k in keys:
            message += command
            message += k
            message += b'\x00\x00\x00\x00' # value
            message += b'\x00\x00\x00\x00' # addr
            message += b'\x00\x00\x00\x00\x00\x00\x00\x00' # mask
            message += b'\x00\x00\x00\x00' # pri
            message += b'\x00\x00\x00\x08' # search command
        rdata = self._sendrecv(message)
        values = []
        if self.debug:
            print('dest', binascii.hexlify(rdata[:6]))
            print('src', binascii.hexlify(rdata[6:6+6]))
            print('header', binascii.hexlify(rdata[6+6:6+6+2]))
        for i in range(num):
            offset = 14+(i*64)
            values.append([rdata[offset:offset+64][40:44], rdata[offset:offset+64][60:64]])
            if self.debug:
                print(binascii.hexlify(rdata[offset:offset+64]))
        return values

    def erase(self, keys):
        num = len(keys)
        if(num > 128):
            return []
        command = bytearray([0, num, 0, 0])
        message = b''
        for k in keys:
            message += command
            message += k
            message += b'\x00\x00\x00\x00' # value
            message += b'\x00\x00\x00\x00' # addr
            message += b'\x00\x00\x00\x00\x00\x00\x00\x00' # mask
            message += b'\x00\x00\x00\x00' # pri
            message += b'\x00\x00\x00\x01' # erase command
        rdata = self._sendrecv(message)
        addrs = []
        if self.debug:
            print('dest', binascii.hexlify(rdata[:6]))
            print('src', binascii.hexlify(rdata[6:6+6]))
            print('header', binascii.hexlify(rdata[6+6:6+6+2]))
        for i in range(num):
            offset = 14+(i*64)
            addrs.append([rdata[offset:offset+64][44:48], rdata[offset:offset+64][60:64]])
            if self.debug:
                print(binascii.hexlify(rdata[offset:offset+64]))
        return addrs

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("usage: {} ethernet-dev-name".format(sys.argv[0]))
        sys.exit(0)
    dev = sys.argv[1]
    num = 16 if len(sys.argv) < 3 else int(sys.argv[2])
    axonerve = Axonerve(dev)
    
    axonerve.reset()

    k0 = b''
    k0 += b'\x01\x02\x03\x04\x05\x06\x07\x08' # key
    k0 += b'\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10'
    k0 += b'\x11\x12\x13\x14\x15\x16\x17\x18'
    k0 += b'\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20'
    k0 += b'\x29\x2a\x2b\x2c'

    v0 = b'\x34\x34\x34\x34'

    print("*** test (search-write-search-erase-search) ***")

    print("search")
    ret = axonerve.search([k0])
    print(ret)
    
    print("write")
    ret = axonerve.write([[k0, v0]])
    print(ret)
    
    print("search")
    ret = axonerve.search([k0])
    print(ret)
    
    print("erase")
    ret = axonerve.erase([k0])
    print(ret)
    
    print("search")
    ret = axonerve.search([k0])
    print(ret)
    
    k1 = b''
    k1 += b'\x02\x02\x03\x04\x05\x06\x07\x08' # key
    k1 += b'\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10'
    k1 += b'\x11\x12\x13\x14\x15\x16\x17\x18'
    k1 += b'\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20'
    k1 += b'\x29\x2a\x2b\x2c'

    v1 = b'\xde\xad\xbe\xef'
    
    print("*** test (search-write-search-erase-search) 2 items ***")
    
    print("search (2 keys)")
    ret = axonerve.search([k0, k1])
    print(ret)
    
    print("write (2 key-values)")
    ret = axonerve.write([[k0, v0], [k1, v1]])
    print(ret)
    
    print("search (2 keys)")
    ret = axonerve.search([k0, k1])
    print(ret)
    
    print("erase (2 keys)")
    ret = axonerve.erase([k0, k1])
    print(ret)
    
    print("search (2 keys)")
    ret = axonerve.search([k0, k1])
    print(ret)

    print("*** test (write-search-reset-search) ***")

    print("write (2 key-values)")
    ret = axonerve.write([[k0, v0], [k1, v1]])
    print(ret)
    
    print("search (2 keys)")
    ret = axonerve.search([k0, k1])
    print(ret)

    print("reset")
    axonerve.reset()
    
    print("search (2 keys)")
    ret = axonerve.search([k0, k1])
    print(ret)

    num = 16 if num <= 0 else num
    print("*** test (search-write-search-erase-search) {} items ***".format(num))
    
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
    print("search")
    ret = axonerve.search(k)
    for r in ret:
        print(r)
    print("write")
    ret = axonerve.write(kv)
    for r in ret:
        print(r)
    print("search")
    ret = axonerve.search(k)
    for r in ret:
        print(r)
    print("erase")
    ret = axonerve.erase(k)
    for r in ret:
        print(r)
    print("search")
    ret = axonerve.search(k)
    for r in ret:
        print(r)
