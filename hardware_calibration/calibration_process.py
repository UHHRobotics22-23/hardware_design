from threading import Thread
from time import sleep, time
import socket

TARGET_ADDR = "192.168.42.1"
TARGET_PORT = 8888

MIN = 70
MAX = 140

stop = False

CURRENT_POS = MAX

def result_process(sock: socket.socket):
    global stop, CURRENT_POS
    #recv_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    #recv_sock.bind(("0.0.0.0", TARGET_PORT))
    while not stop:
        try:
            data, addr = sock.recvfrom(1024)
            print("received message: %s" % data)
            data = data.decode("utf-8")
            if data[:2] == "p ":
                CURRENT_POS = int(data[2:])
                print("Current pos: %d" % CURRENT_POS)
        except TimeoutError:
            continue
        
def main():
    global stop
    try:
        f = open(f"calibration_pos-{time()}.csv", "w")
        data_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        
        recv_thread = Thread(target=result_process, args=(data_sock,))
        
        data_sock.settimeout(1)
        data_sock.sendto(b"l", (TARGET_ADDR, TARGET_PORT))
        recv_thread.start()
        data_sock.sendto(b"p", (TARGET_ADDR, TARGET_PORT))
        
        # do sweep
        for i in range(MAX, MIN-1, -1):
            f.write(f"{time()},{i}\n")
            send_til_pos(data_sock, i)
            
        for i in range(MIN, MAX+1):
            f.write(f"{time()},{i}\n")
            send_til_pos(data_sock, i)
    
    except KeyboardInterrupt:
        print("Interrupted")
    
    stop = True
    recv_thread.join()
    f.close()

def send_til_pos(sock, pos):
    global CURRENT_POS
    while CURRENT_POS != pos:
        print("Sending pos", pos, "Current pos", CURRENT_POS)
        sock.sendto((f"s {pos}").encode(), (TARGET_ADDR, TARGET_PORT))
        sock.sendto(b"p", (TARGET_ADDR, TARGET_PORT))
        sleep(1)
    sleep(2)

if __name__ == "__main__":
    main()