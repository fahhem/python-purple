import purple
import ecore
import getpass
import sys

class NullClient:
    def __init__(self):
        self.p = purple.Purple()
        self.account = None

    def execute(self):
        self.p.purple_init()

    def set_protocol(self, protocol):
        for i in self.p.get_protocols():
            if i[1] == protocol:
                print "-- NULLCLIENT --: Choosing %s as protocol" % protocol
                self.protocol = i[0]
                print "-- NULLCLIENT --: Protocol successfully chosen: %s" % i[0]
                return

    def new_account(self, username, protocol, password):
        self.account = purple.Account(username, protocol)
        self.account.set_password(password)
        self.account.set_enabled("carman-purple-python", True)

    def get_buddies(self):
        buddies = self.account.get_buddies_online()
        print buddies

def getuser():
    sys.stdout.write("GTalk account: ")
    username = sys.stdin.readline()
    return username[:-1]

def getpassword():
    return getpass.getpass()

if __name__ == '__main__':

    client = NullClient()
    client.execute()
    client.set_protocol("XMPP")
    username = getuser()
    password = getpassword()
    client.new_account(username, client.protocol, password)

    client.p.connect()
    ecore.timer_add(20, client.get_buddies)
    ecore.main_loop_begin()
