#!/usr/bin/env python3

from ibapi.client import EClient
from ibapi.wrapper import EWrapper
import threading
import time
import sys
import argparse


class IBapi(EWrapper, EClient):
    def __init__(self):
        EClient.__init__(self, self)
        self.is_connected = False
        self.next_order_id_received = threading.Event()

    def nextValidId(self, orderId):
        super().nextValidId(orderId)
        self.nextorderId = orderId
        print('Next Valid Id:', self.nextorderId)
        self.next_order_id_received.set()

    def error(self, reqId, errorCode, errorString):
        print('Error:', reqId, errorCode, errorString)
        if reqId == -1 and errorCode == 1100:
            print('Connection rejected. Please check that the API settings are correct.')
            sys.exit(1)
        elif errorCode == 504:
            print('Gateway server disconnected. Please check your internet connection.')
            sys.exit(1)

    def connectAck(self):
        super().connectAck()
        self.is_connected = True

    def connectionClosed(self):
        super().connectionClosed()
        self.is_connected = False


def run_loop():
    app.run()


parser = argparse.ArgumentParser(description='Check if Interactive Brokers API is running and responding.')
parser.add_argument('-a', '--address', type=str, default='127.0.0.1', help='IP address of the gateway server')
parser.add_argument('-p', '--port', type=int, default=7497, help='Port number to connect to')
parser.add_argument('-c', '--client_id', type=int, default=123, help='Client ID to use for the connection')
parser.add_argument('-r', '--retries', type=int, default=5, help='Number of connection retries before giving up')
args = parser.parse_args()

app = IBapi()

for i in range(args.retries):
    print(f'Attempting to connect to IB API. Attempt {i+1} of {args.retries}...')
    app.connect(args.address, args.port, args.client_id)

    # Start the run loop in a separate thread
    api_thread = threading.Thread(target=run_loop)
    api_thread.start()

    # Wait for the connection to be established
    time.sleep(2)

    if app.is_connected:
        print('IB API is connected and ready for use.')
        app.reqIds(-1)  # Request the next order ID

        # Wait for nextValidId() callback
        app.next_order_id_received.wait()

        app.disconnect()
        sys.exit(0)

print(f'Failed to connect to IB API after {args.retries} attempts.')
sys.exit(1)

