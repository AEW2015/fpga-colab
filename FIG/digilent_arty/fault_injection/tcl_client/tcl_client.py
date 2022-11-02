import socket

class Tcl_client:
    def __init__(self):
        self.HOST = "localhost"
        self.PORT = 8953
        self.socket = None

    def open(self):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.connect((self.HOST, self.PORT))

    def send_command(self, command):
        command += '\n'
        self.socket.sendall(command.encode())
        value = self.socket.recv(2048).decode().rstrip()
        return value

    def close(self):
        if self.socket:
            self.socket.close()