#!/usr/bin/env python

import etk
import ecore
import purple
from xml.dom import minidom

class MainWindow:
    def __init__(self, quit_cb):
        self.bt_cbs = {}
        self.new_acc_bt_cbs = {}
        self.send_cbs = {}
        self.quit_cb = quit_cb

    def init_window(self):
        # Main vbox
        vbox = etk.VBox(homogeneous=False)

        hbox_cmd = etk.HBox(homogeneous=False)
        self.cmd_entry = etk.Entry()
        self.lcmd = etk.Label(text="Type your message: ")
        hbox_cmd.append(self.lcmd, etk.HBox.START, etk.HBox.START, 0)
        hbox_cmd.append(self.cmd_entry, etk.HBox.START, etk.HBox.EXPAND_FILL, 0)

        vbox_accs = etk.VBox()
        self.accslistmodel = etk.ListModel()
        self.accslist = etk.List(model=self.accslistmodel,\
                columns=[(10, etk.TextRenderer(slot=0),\
                False)], selectable=True,\
                animated_changes=True)
        vbox_accs.append(self.accslist, etk.VBox.START, etk.VBox.EXPAND_FILL, 0)

        hbox_buttons = etk.HBox(homogeneous=False)
        send_bt = etk.Button(label="Send")
        send_bt.on_clicked(self._send_bt_cb)
        conn_bt = etk.Button(label="Connect")
        conn_bt.on_clicked(self.login_window)
        new_account_bt = etk.Button(label="New Account")
        new_account_bt.on_clicked(self._new_account)
        hbox_buttons.append(send_bt, etk.HBox.START, etk.HBox.NONE, 0)
        hbox_buttons.append(conn_bt, etk.HBox.START, etk.HBox.NONE, 0)
        hbox_buttons.append(new_account_bt, etk.HBox.START, etk.HBox.NONE, 0)

        hbox_panel = etk.HBox()

        vbox_buddies = etk.VBox()
        self.blistmodel = etk.ListModel()
        self.blist = etk.List(model=self.blistmodel,\
                                     columns=[(10, etk.TextRenderer(slot=0), False)],\
                                     selectable=True, animated_changes=True)
        vbox_buddies.append(self.blist, etk.VBox.START, etk.VBox.EXPAND_FILL, 0)

        vbox_txt_area = etk.VBox()
        self.txt_area = etk.Label()
        self.txt_area.text = "<br> "

        vbox_txt_area.append(self.txt_area, etk.VBox.START, etk.VBox.EXPAND_FILL, 0)

        hbox_panel.append(vbox_txt_area, etk.HBox.START, etk.HBox.EXPAND_FILL, 0)
        hbox_panel.append(vbox_buddies, etk.HBox.END, etk.HBox.EXPAND_FILL, 0)
        hbox_panel.append(vbox_accs, etk.HBox.END, etk.HBox.EXPAND_FILL, 0)

        self.lstatus = etk.Label(text="Connection status")

        vbox.append(hbox_panel, etk.VBox.START, etk.VBox.EXPAND_FILL, 0)
        vbox.append(hbox_cmd, etk.VBox.END, etk.VBox.FILL, 0)
        vbox.append(hbox_buttons, etk.VBox.END, etk.VBox.NONE, 5)
        vbox.append(self.lstatus, etk.VBox.END, etk.VBox.FILL, 0)

        self._window = etk.Window(title="NullClient-Etk", size_request=(600, 600), child=vbox)
        self._window.on_destroyed(self.quit_cb)
        self._window.show_all()

    def login_window(self, pointer):
        self.login_password = etk.Entry()
        confirm_login_bt = etk.Button(label="Ok")
        confirm_login_bt.on_clicked(self._conn_bt_cb)
        vbox_login =  etk.VBox()
        vbox_login.append(self.login_password, etk.VBox.START, etk.VBox.FILL, 0)
        vbox_login.append(confirm_login_bt, etk.VBox.END, etk.VBox.NONE, 0)
        self.login_win = etk.Window(title="Password", size_request=(190, 80),
                child=vbox_login)
        self.login_win.show_all()

    def _conn_bt_cb(self, pointer):
        if self.bt_cbs.has_key("on_clicked"):
            self.bt_cbs["on_clicked"](self.login_password.text)
            self.login_win.destroy()

    def _send_bt_cb(self, pointer):
        bname = self.blist.selected_rows[0][0]
        msg = self.cmd_entry.text
        if bname and msg != "":
            if self.send_cbs.has_key("on_clicked"):
                self.send_cbs["on_clicked"](bname, msg)
        else:
            print "Buddy not selected!"
        self.cmd_entry.text = ""

    def selected_accs(self):
        try:
            acc = self.accslist.selected_rows[0][0]
            if acc:
                return acc
            else:
                return None
        except:
            return None

    def _new_account(self, pointer):
        if self.new_acc_bt_cbs.has_key("on_clicked"):
            self.new_acc_bt_cbs["on_clicked"]()


    def new_buddy(self, b):
            if [b] not in self.blistmodel.elements:
                self.blistmodel.append([b])

    def remove_buddy(self, bname):
        self.blistmodel.remove([bname])

    def new_account(self, a):
        if [a] not in self.accslistmodel.elements:
            self.accslistmodel.append([a])

    def set_panel_text(self, txt):
        self.txt_area = txt

    def add_bt_conn_cb(self, cb):
        if callable(cb):
            self.bt_cbs["on_clicked"] = cb

    def add_account_cb(self, cb):
        if callable(cb):
            self.new_acc_bt_cbs["on_clicked"] = cb

    def add_send_cb(self, cb):
        if callable(cb):
            self.send_cbs["on_clicked"] = cb

    def add_quit_cb(self, cb):
        if callable(cb):
            self.quit_cb = cb

    def show(self):
        if self._window:
            self._window.show_all()

class NullClientPurple(object):
    def __init__(self):
        self.purple = purple.Purple(debug_enabled=False)
        self.window = MainWindow(self.quit)
        self.buddies = {} #all buddies
        self.conversations = {}
        self.protocol_id = "prpl-jabber"
        self.account = None

        self.purple.add_callback("blist", "update", self.__purple_update_blist_cb)
        self.purple.add_callback("connection", "connect-progress", self.__purple_conn_progress_cb)
        self.purple.add_callback("connection", "connected", self.__purple_connected_cb)
        self.purple.add_callback("connection", "disconnected", self.__purple_disconnected_cb)
        self.purple.add_callback("conversation", "write-im", self.__purple_write_im_cb)

        self.purple.purple_init()

        #Initializing UI
        self.window.add_bt_conn_cb(self.connect)
        self.window.add_send_cb(self.send_msg)
        self.window.add_account_cb(self.add_account)
        self.window.init_window()

    def __purple_update_blist_cb(self, type, name=None, alias=None, \
                                totalsize=None, currentsize=None, \
                                online=None):
        if self.account and name != None and type == 2:
            if not self.buddies.has_key(name):
                b = purple.Buddy()
                b.new_buddy(self.account, name, alias)
                self.buddies[name] = b
            elif self.buddies[name].online:
                self.window.new_buddy(name)

    def __purple_conn_progress_cb(self, text, step, step_count):
        if self.window:
            self.window.lstatus.text = text

    def __purple_connected_cb(self, *data):
        if self.window:
            self.window.lstatus.text = "Connected"

    def __purple_disconnected_cb(self, *data):
        if self.window:
            self.window.lstatus.text = "Disconnected"

    def __purple_write_im_cb(self, sender, alias, message):
        if self.window:
            if alias:
                self.window.txt_area.text += alias + ": " + message + "<br> "
            else:
                self.window.txt_area.text += sender + ": " + message + "<br> "
            self.window.show()

    def __purple_signal_buddy_signed_off_cb(self, name, alias):
        if self.buddies.has_key(name):
            self.buddies[name] = None
            self.buddies.pop(name)
            print "[DEBUG]: Buddy removed!"
        self.window.remove_buddy(name)

    def __purple_signal_jabber_receiving_xmlnode_cb(self, message):
    xml = minidom.parse(message)

    for msg in xml.getElementsByTagName("message"):
        who = msg.getAttribute("from")
        for geoloc in msg.getElementsByTagNameNS("http://jabber.org/protocol/geoloc", "geoloc"):
            lat = geoloc.getElementsByTagName("lat")[0].childNodes[0].nodeValue
            lon = geoloc.getElementsByTagName("lon")[0].childNodes[0].nodeValue
            print "who: %s lat: %s lon: %s" % (who, lat, lon)

    def add_account(self):
        username = "carmanplugintest@gmail.com"
        host = "172.18.216.211"
        port = 8080
        self.purple.account_add(username, self.protocol_id, host, port)
        for account in self.purple.accounts.keys():
            self.window.new_account(account)

    def connect(self, password):
        username_acc = self.window.selected_accs()
        if username_acc:
            self.account = self.purple.account_verify(username_acc)
            self.account.get_protocol_options()
            self.account.set_enabled("carman-purple-python", True)
            self.account.password = password
            self.purple.connect()
            self.purple.signal_connect("buddy-signed-off", self.__purple_signal_buddy_signed_off_cb)
            self.purple.signal_connect("jabber-receiving-xmlnode", self.__purple_signal_jabber_receiving_xmlnode_cb)

    def send_msg(self, name, msg):
        if not self.conversations.has_key(name):
            conv = purple.Conversation()
            conv.initialize(self.account, "IM", name)
            self.conversations[name] = conv
        self.conversations[name].write(msg)

    def quit(self, o):
        print "[DEBUG]: quitting"
        for i in self.conversations:
            self.conversations[i].destroy()
            self.conversations[i] = None
        self.conversations = None
        self.purple.destroy()
        ecore.main_loop_quit()

if __name__ == '__main__':
    nullpurple = NullClientPurple()
    ecore.main_loop_begin()
