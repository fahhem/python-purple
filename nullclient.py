import purple
import ecore
import getpass
import sys
from xml.dom import minidom


class ClientModel:
    def __init__(self):
        self.purple = purple.Purple(debug_enabled=True)
        self.purple.purple_init()
        self.account = purple.Account()

    def add_account(self, acc):
        ''' @param acc: {'username': "foo@gmail.com", 'protocol': "XMPP"} '''

        new_acc = self.account.new(acc['username'], acc['protocol'])

        return new_acc

    def get_protocols(self):
        return self.account.protocol.get_all()

    def get_protocol_options(self, protocol_id):
        return self.account.protocol.get_options(protocol_id)

    def set_account_info(self, acc, info):
        ''' @param info: {protocol: 'prpl-jabber', alias: '', password: ' ', server: 'new server', port: '' } ||
                    {server: 'new server'} '''

        if info.has_key('protocol'):
            self.account.set_protocol_id(acc, info['protocol'])
        if info.has_key('alias'):
            self.account.set_alias(acc, info['alias'])
        if info.has_key('password'):
            self.account.set_password(acc, info['password'])

        self.account.protocol.set_options(acc, info)

    def get_account_info(self, acc):
        info = {}
        po = self.account.protocol.get_options(acc[1], acc[0])
        info['protocol'] = self.account.get_protocol_id(acc)
        info['alias'] = self.account.get_alias(acc)
        info['password'] = self.account.get_password(acc)
        info['connect_server'] = po['connect_server'][1]
        info['port'] = po['port'][1]

        return info

    def set_account_proxy(self, acc, info):
        self.account.proxy.set_info(acc, info)

    def account_connect(self, acc):
        self.account.set_enabled(acc, "carman-purple-python", True)
        # self.account.connect(acc)
        self.purple.connect()

    def account_disconnect(self, acc):
        self.account.disconnect(acc)

   
class ClientCtrl:
    def __init__(self):
        self.clientmodel = ClientModel()
        new_acc = {}
        acc_info = {}
        new_acc['username'] = self.getuser()
        new_acc['protocol'] = 'prpl-jabber'

        acc = self.clientmodel.add_account(new_acc)

        acc_info = self.clientmodel.get_account_info(acc)
        acc_info['password'] = self.getpassword()
        acc_info['connect_server'] = 'talk.google.com'
        acc_info['port'] = 443
        acc_info['old_ssl'] = True
        self.clientmodel.set_account_info(acc, acc_info)

        acc_proxy = {}
        acc_proxy['type'] = 'HTTP' 
        acc_proxy['host'] = '172.18.216.211'
        acc_proxy['port'] = 8080
        self.clientmodel.set_account_proxy(acc, acc_proxy)

        self.clientmodel.account_connect(acc)

    def getuser(self):
        sys.stdout.write("GTalk account: ")
        username = sys.stdin.readline()
        return username[:-1]

    def getpassword(self):
        return getpass.getpass()

if __name__ == '__main__':

    ctrl = ClientCtrl()

    ecore.main_loop_begin()
