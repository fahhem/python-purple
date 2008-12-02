import purple

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

if __name__ == '__main__':

    client = NullClient()
    client.execute()
    client.set_protocol("XMPP")
    client.new_account("seu_email@email.com", client.protocol,"sua_senha_aqui")

    client.p.connect()
    client.p.run_loop()
