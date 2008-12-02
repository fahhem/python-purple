import etk
import ecore
import purple

cbs = {}
acc_cbs = {}
blist_cbs = {}
conn_cbs = {}
conv_cbs = {}
notify_cbs = {}
request_cbs = {}
signal_cbs = {}

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
blist_cbs["new_node"] = blist_callback
blist_cbs["show"] = blist_callback
#blist_cbs["update"] = blist_callback
blist_cbs["remove"] = blist_callback
blist_cbs["destroy"] = blist_callback
blist_cbs["set_visible"] = blist_callback
blist_cbs["request_add_buddy"] = blist_callback
blist_cbs["request_add_chat"] = blist_callback
blist_cbs["request_add_group"] = blist_callback

cbs["blist"] = blist_cbs

def conn_callback(name):
    print "---- connection callback example: %s" % name

def conn_progress_cb(data):
    return "Connection in progress..."

#conn_cbs["connect_progress"] = conn_progress_cb
#conn_cbs["connected"] = conn_callback
#conn_cbs["disconnected"] = conn_callback
conn_cbs["notice"] = conn_callback
conn_cbs["report_disconnect"] = conn_callback
conn_cbs["network_connected"] = conn_callback
conn_cbs["network_disconnected"] = conn_callback
conn_cbs["report_disconnect_reason"] = conn_callback

cbs["connection"] = conn_cbs

def conv_callback(name):
    print "---- conversation callback example: %s" % name

conv_cbs["create_conversation"] = conv_callback
conv_cbs["destroy_conversation"] = conv_callback
conv_cbs["write_chat"] = conv_callback
conv_cbs["write_im"] = conv_callback
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

def buddy_signed_off_cb(name, bname):
    print "---- sign off from buddy %s" % bname

def receiving_im_msg_cb(sender, name, message):
    print "---- receiving IM message from %s: %s" % (name, message)
    return False

#signal_cbs["buddy_signed_off"] = buddy_signed_off_cb
signal_cbs["receiving_im_msg"] = receiving_im_msg_cb


class MainWindow:
    def __init__(self, quit_cb):
        self.bt_cbs = {}
        self.quit_cb = quit_cb

    def init_window(self):
        # Main vbox
        vbox = etk.VBox(homogeneous=False)

        hbox_cmd = etk.HBox(homogeneous=False)
        self.cmd_entry = etk.Entry()
        lcmd = etk.Label(text="Type your message: ")
        hbox_cmd.append(lcmd, etk.HBox.START, etk.HBox.START, 0)
        hbox_cmd.append(self.cmd_entry, etk.HBox.START, etk.HBox.EXPAND_FILL, 0)

        hbox_buttons = etk.HBox(homogeneous=False)
        send_bt = etk.Button(label="Send")
        send_bt.on_clicked(self._send_bt_cb)
        conn_bt = etk.Button(label="Connect")
        conn_bt.on_clicked(self._conn_bt_cb)
        hbox_buttons.append(send_bt, etk.HBox.START, etk.HBox.NONE, 0)
        hbox_buttons.append(conn_bt, etk.HBox.START, etk.HBox.NONE, 0)

        hbox_panel = etk.HBox()

        vbox_buddies = etk.VBox()
        self.blistmodel = etk.ListModel()
        self.blist = etk.List(model=self.blistmodel,\
                                     columns=[(10, etk.TextRenderer(slot=0), False)],\
                                     selectable=True, animated_changes=True)
        vbox_buddies.append(self.blist, etk.VBox.START, etk.VBox.EXPAND_FILL, 0)

        vbox_txt_area = etk.VBox()
        self.txt_area = etk.Label()
        vbox_txt_area.append(self.txt_area, etk.VBox.START, etk.VBox.EXPAND_FILL, 0)

        hbox_panel.append(vbox_txt_area, etk.HBox.START, etk.HBox.EXPAND_FILL, 0)
        hbox_panel.append(vbox_buddies, etk.HBox.END, etk.HBox.EXPAND_FILL, 0)

        self.lstatus = etk.Label(text="Connection status")

        vbox.append(hbox_panel, etk.VBox.START, etk.VBox.EXPAND_FILL, 0)
        vbox.append(hbox_cmd, etk.VBox.END, etk.VBox.FILL, 0)
        vbox.append(hbox_buttons, etk.VBox.END, etk.VBox.NONE, 5)
        vbox.append(self.lstatus, etk.VBox.END, etk.VBox.FILL, 0)

        self._window = etk.Window(title="NullClient-Etk", size_request=(600, 600), child=vbox)
        self._window.on_destroyed(self.quit_cb)
        self.set_global_callbacks()
        self._window.show_all()

    def set_global_callbacks(self):
        global cbs
        cbs["connection"]["connect_progress"] = self._purple_conn_status_cb
        cbs["connection"]["disconnected"] = self._purple_disconnected_status_cb
        cbs["connection"]["connected"] = self._purple_connected_cb

    def _conn_bt_cb(self, pointer):
        if self.bt_cbs.has_key("on_clicked"):
            self.bt_cbs["on_clicked"]()

    def _send_bt_cb(self, pointer):
        bname = self.blist.selected_rows[0][0]
        if bname:
            print "ITEM: %s" % bname

    def _purple_conn_status_cb(self, txt, step, step_count):
            self.lstatus.text = txt

    def _purple_connected_cb(self):
        self.lstatus.text = "Connected"

    def new_buddy(self, b):
            if [b] not in self.blistmodel.elements:
                self.blistmodel.append([b])

    def remove_buddy(self, bname):
        self.blistmodel.remove([bname])

    def _purple_disconnected_status_cb(self, pointer):
        self.lstatus.text = "Disconnected"

    def set_panel_text(self, txt):
        self.txt_area = txt

    def add_bt_conn_cb(self, cb):
        if callable(cb):
            self.bt_cbs["on_clicked"] = cb

    def add_quit_cb(self, cb):
        if callable(cb):
            self.quit_cb = cb


class NullClientPurple:
    def __init__(self):
        self.p = purple.Purple(debug_enabled=False)
        self.window = MainWindow(self.quit)
        self.buddies = []
        self.account = None
        self.protocol = None
        self.username = "carmanplugintest@gmail.com"
        self.password = "abc123def"

        global cbs
        global signal_cbs
        cbs["blist"]["update"] = self._purple_blist_new_cb
        signal_cbs["buddy_signed_off"] = self._purple_signal_sign_off_cb
        self.p.purple_init(cbs)

        #Initializing UI
        self.window.add_bt_conn_cb(self.connect)
        self.window.init_window()

    def _purple_blist_new_cb(self, pointer):
        """ FIXME: Hack! to fill blist on UI """
        buddies = self.account.get_buddies_online()
        for i in buddies:
            if i not in self.buddies:
                self.buddies.append(i)
                self.window.new_buddy(i)

    def _purple_signal_sign_off_cb(self, name, bname):
        self.buddies.remove(bname)
        self.window.remove_buddy(bname)

    def set_protocol(self, protocol):
        for p in self.p.get_protocols():
            if p.get_name() == protocol:
                self.protocol = p
                return

    def connect(self):
        self.set_protocol("XMPP")
        self.account = purple.Account(self.username, self.protocol.get_id())
        self.account.set_password(self.password)

        self.account.proxy.set_type(purple.ProxyInfoType().HTTP)
        self.account.proxy.set_host("172.18.216.211")
        self.account.proxy.set_port(8080)

        self.account.get_protocol_options()

        self.account.set_enabled("carman-purple-python", True)
        self.p.connect()
        self.p.attach_signals(signal_cbs)

    def quit(self, o):
        print "quitting"
        self.p = None
        ecore.main_loop_quit()

if __name__ == '__main__':

    nullpurple = NullClientPurple()
    ecore.main_loop_begin()