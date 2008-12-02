import purple
import ecore
import getpass
import sys
from xml.dom import minidom

cbs = {}
acc_cbs = {}
blist_cbs = {}
conn_cbs = {}
conv_cbs = {}
notify_cbs = {}
request_cbs = {}

def account_callback(name):
    print "---- account callback example: %s" % name

acc_cbs["notify_added"] = account_callback
acc_cbs["status_changed"] = account_callback
acc_cbs["request_add"] = account_callback
acc_cbs["request_authorize"] = account_callback
acc_cbs["close_account_request"] = account_callback

cbs["account"] = acc_cbs

def blist_callback(name):
    print "---- blist callback example: %s" % name

blist_cbs["new_list"] = blist_callback
blist_cbs["show"] = blist_callback
blist_cbs["destroy"] = blist_callback
blist_cbs["set_visible"] = blist_callback
blist_cbs["request_add_buddy"] = blist_callback
blist_cbs["request_add_chat"] = blist_callback
blist_cbs["request_add_group"] = blist_callback

def new_node_cb(type, name=None, totalsize=None, currentsize=None, online=None):
    if type == 0:
        print "---- blist callback: new node (group): %s (%s/%s) (%s online)" % \
                (name, totalsize, currentsize, online)
    elif type == 1:
        print "---- blist callback: new node (contact): %s (%s/%s) (%s online)" % \
                (name, totalsize, currentsize, online)
    elif type == 2: # totalsize = alias
        print "---- blist callback: new node (buddy): %s (%s)" % (name, totalsize)
    elif type == 3:
        print "---- blist callback: new node (chat): %s" % alias
    elif type == 4:
        print "---- blist callback: new node (other type)"
    else:
        print "---- blist callback: new node (unknown type %s)" % type

def update_cb(type, name=None, totalsize=None, currentsize=None, online=None):
    if type == 0:
        print "---- blist callback: update (group): %s (%s/%s) (%s online)" % \
                (name, totalsize, currentsize, online)
    elif type == 1:
        print "---- blist callback: update (contact): %s (%s/%s) (%s online)" % \
                (name, totalsize, currentsize, online)
    elif type == 2: # totalsize = alias
        print "---- blist callback: update (buddy): %s (%s)" % \
                (name, totalsize)
    elif type == 3:
        print "---- blist callback: update (chat): %s" % alias
    elif type == 4:
        print "---- blist callback: update (other type)"
    else:
        print "---- blist callback: update (unknown type %s)" % type

def remove_cb(type, name=None, totalsize=None, currentsize=None, online=None):
    if type == 0:
        print "---- blist callback: remove (group): %s (%s/%s) (%s online)" % \
                (name, totalsize, currentsize, online)
    elif type == 1:
        print "---- blist callback: remove (contact): %s (%s/%s) (%s online)" % \
                (name, totalsize, currentsize, online)
    elif type == 2: # totalsize = alias
        print "---- blist callback: remove (buddy): %s (%s)" % \
                (name, totalsize)
    elif type == 3:
        print "---- blist callback: remove (chat): %s" % alias
    elif type == 4:
        print "---- blist callback: remove (other type)"
    else:
        print "---- blist callback: remove (unknown type %s)" % type

blist_cbs["new_node"] = new_node_cb
blist_cbs["update"] = update_cb
blist_cbs["remove"] = remove_cb

cbs["blist"] = blist_cbs

def conn_callback(name):
    print "---- connection callback example: %s" % name

conn_cbs["notice"] = conn_callback
conn_cbs["network_connected"] = conn_callback
conn_cbs["network_disconnected"] = conn_callback

def connect_progress_cb(text, step, step_count):
    print "---- connection status: %s [%s/%s]" % (text, step, step_count)

def connected_cb():
    print "---- connection status: Connected"

def disconnected_cb():
    print "---- connection status: Disconnected"

def report_disconnect_cb(text):
    print "---- %s" % text

def report_disconnect_reason_cb(reason, text):
    print "---- %s (%s)" % (text, reason)

conn_cbs["connect_progress"] = connect_progress_cb
conn_cbs["connected"] = connected_cb
conn_cbs["disconnected"] = disconnected_cb
conn_cbs["report_disconnect"] = report_disconnect_cb
conn_cbs["report_disconnect_reason"] = report_disconnect_reason_cb

cbs["connection"] = conn_cbs

def conv_callback(name):
    print "---- conversation callback example: %s" % name

def write_im_cb(name, message):
    print "---- (conversation) write_im: %s %s" % (name, message)

conv_cbs["create_conversation"] = conv_callback
conv_cbs["destroy_conversation"] = conv_callback
conv_cbs["write_chat"] = conv_callback
conv_cbs["write_im"] = write_im_cb
conv_cbs["write_conv"] = conv_callback
conv_cbs["chat_add_users"] = conv_callback
conv_cbs["chat_rename_user"] = conv_callback
conv_cbs["chat_remove_users"] = conv_callback
conv_cbs["chat_update_user"] = conv_callback
conv_cbs["present"] = conv_callback
conv_cbs["has_focus"] = conv_callback
conv_cbs["custom_smiley_add"] = conv_callback
conv_cbs["custom_smiley_write"] = conv_callback
conv_cbs["custom_smiley_close"] = conv_callback
conv_cbs["send_confirm"] = conv_callback

cbs["conversation"] = conv_cbs

def notify_callback(name):
    print "----  notify callback example: %s" % name

notify_cbs["notify_message"] = notify_callback
notify_cbs["notify_email"] = notify_callback
notify_cbs["notify_emails"] = notify_callback
notify_cbs["notify_formatted"] = notify_callback
notify_cbs["notify_searchresults"] = notify_callback
notify_cbs["notify_searchresults_new_rows"] = notify_callback
notify_cbs["notify_userinfo"] = notify_callback
notify_cbs["notify_uri"] = notify_callback
notify_cbs["close_notify"] = notify_callback

cbs["notify"] = notify_cbs

def request_callback(name):
    print "---- request callback example: %s" % name

request_cbs["request_input"] = request_callback
request_cbs["request_choice"] = request_callback
request_cbs["request_action"] = request_callback
request_cbs["request_fields"] = request_callback
request_cbs["request_file"] = request_callback
request_cbs["close_request"] = request_callback
request_cbs["request_folder"] = request_callback

cbs["request"] = request_cbs

def buddy_signed_off_cb(name):
    print "---- (signal) sign off from buddy %s" % name

def receiving_im_msg_cb(sender, name, message):
    print "---- (signal) receiving IM message from %s: %s" % (name, message)
    return False

def jabber_received_xmlnode_cb(message):
    xml = minidom.parse(message)

    for msg in xml.getElementsByTagName("message"):
        who = msg.getAttribute("from")
        for geoloc in msg.getElementsByTagNameNS("http://jabber.org/protocol/geoloc", "geoloc"):
            lat = geoloc.getElementsByTagName("lat")[0].childNodes[0].nodeValue
            lon = geoloc.getElementsByTagName("lon")[0].childNodes[0].nodeValue
            print "who: %s lat: %s lon: %s" % (who, lat, lon)

class NullClient:
    def __init__(self):
        self.p = purple.Purple(debug_enabled=False)
        self.account = None
        self.protocol_id = "prpl-jabber"

    def execute(self):
        global cbs
        self.p.purple_init(cbs)

    def new_account(self, username, password):
        self.account = purple.Account(username, self.protocol_id)
        self.account.password = password

        self.account.proxy.set_type(purple.ProxyInfoType().HTTP)
        self.account.proxy.set_host("172.18.216.211")
        self.account.proxy.set_port(8080)

        self.account.get_protocol_options()

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
    client.p.signal_connect("buddy-signed-off", buddy_signed_off_cb)
    client.p.signal_connect("receiving-im-msg", receiving_im_msg_cb)
    client.p.signal_connect("jabber-receiving-xmlnode", jabber_received_xmlnode_cb)
    username = getuser()
    password = getpassword()
    client.new_account(username, password)

    client.p.connect()
    ecore.timer_add(20, client.get_buddies)
    ecore.main_loop_begin()
