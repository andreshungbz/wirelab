import socket
import time

s = socket.create_connection(("127.0.0.1", 8080))
s.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 4096)  # a tiny receive buffer
s.sendall(b"GET /big?kb=4096 HTTP/1.1\r\nHost: lab\r\nConnection: close\r\n\r\n")
time.sleep(8)  # ask for 4 MB, then read nothing at all for 8 seconds
