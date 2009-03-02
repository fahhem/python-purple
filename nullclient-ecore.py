#
#  Copyright (c) 2008 INdT - Instituto Nokia de Tecnologia
#
#  This file is part of python-purple.
#
#  python-purple is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  python-purple is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import etk
import ecore
import purple

# The information below is needed by libpurple
__NAME__ = "nullclient-ecore"
__VERSION__ = "0.1"
__WEBSITE__ = "N/A"
__DEV_WEBSITE__ = "N/A"

class MainWindow(object):
    def __init__(self):
        # Connect button callback
        self.__connect_button_cb = None

        # Send button callback
        self.__send_button_cb = None

        # New account callback
        self.__new_account_cb = None

        # Exit callback
        self.__exit_cb = None

    def __login_window_cb(self, pointer):
        # Password entry
        self.login_password = etk.Entry()

        # Confirm login button
        confirm_login_bt = etk.Button(label='Ok')
        confirm_login_bt.on_clicked(self.__connect_button_clicked)

        # Login VBox
        vbox = etk.VBox()
        vbox.append(self.login_password, etk.VBox.START, etk.VBox.FILL, 0)
        vbox.append(confirm_login_bt, etk.VBox.END, etk.VBox.NONE, 0)

        # Login window
        self.login_window = etk.Window(title='Password', \
                size_request=(190, 80), child=vbox)
        self.login_window.show_all()

    def __connect_button_clicked(self, pointer):
        # Call connection button callback
        if self.__connect_button_cb:
            self.__connect_button_cb(self.login_password.text)
        self.login_window.destroy()

    def __send_button_clicked(self, pointer):
        # Get selected buddy name from buddy list
        bname = self.blist.selected_rows[0][0]

        # Get message from command entry
        msg = self.cmd_entry.text

        if bname and msg != '':
            # Call send button callback
            if self.__send_button_cb:
                self.__send_button_cb(bname, msg)

        # Clear text from command entry
        self.cmd_entry.text = ''

    def __new_account_button_clicked(self, pointer):
        # Username entry
        self.login_username = etk.Entry()

        # Confirm username button
        confirm_username_bt = etk.Button(label='Ok')
        confirm_username_bt.on_clicked(self.add_account)

        # Username VBox
        vbox = etk.VBox()
        vbox.append(self.login_username, etk.VBox.START, etk.VBox.FILL, 0)
        vbox.append(confirm_username_bt, etk.VBox.END, etk.VBox.NONE, 0)

        # Username window
        self.username_window = etk.Window(title='Username', \
                size_request=(190, 80), child=vbox)
        self.username_window.show_all()

    def __create_accounts_list(self):
        # Accounts list
        self.accslistmodel = etk.ListModel()
        self.accslist = etk.List(model=self.accslistmodel, \
                columns=[(10, etk.TextRenderer(slot=0), False)], \
                selectable=True, animated_changes=True)

        #Appending accounts list to VBox
        vbox = etk.VBox()
        vbox.append(self.accslist, etk.VBox.START, etk.VBox.EXPAND_FILL, 0)
        return vbox

    def __create_buddies_list(self):
        # Buddies list
        self.blistmodel = etk.ListModel()
        self.blist = etk.List(model=self.blistmodel, \
                columns=[(10, etk.TextRenderer(slot=0), False)], \
                selectable=True, animated_changes=True)

        # Appending buddies list to VBox
        vbox = etk.VBox()
        vbox.append(self.blist, etk.VBox.START, etk.VBox.EXPAND_FILL, 0)
        return vbox

    def __create_buttons_bar(self):
        # Send button
        send_button = etk.Button(label='Send')
        send_button.on_clicked(self.__send_button_clicked)

        # Connect button
        conn_button = etk.Button(label='Connect')
        conn_button.on_clicked(self.__login_window_cb)

        # New account button
        new_acc_button = etk.Button(label='New Account')
        new_acc_button.on_clicked(self.__new_account_button_clicked)

        # Appending all buttons to HBox
        hbox = etk.HBox(homogeneous=False)
        hbox.append(send_button, etk.HBox.START, etk.HBox.NONE, 0)
        hbox.append(conn_button, etk.HBox.START, etk.HBox.NONE, 0)
        hbox.append(new_acc_button, etk.HBox.START, etk.HBox.NONE, 0)
        return hbox

    def __create_command_entry_box(self):
        # Command entry box
        self.cmd_entry = etk.Entry()
        self.cmd_label = etk.Label(text='Type your message: ')

        # appending command entry and label to HBox
        hbox = etk.HBox(homogeneous=False)
        hbox.append(self.cmd_label, etk.HBox.START, \
                etk.HBox.START, 0)
        hbox.append(self.cmd_entry, etk.HBox.START, \
                etk.HBox.EXPAND_FILL, 0)
        return hbox

    def __create_text_area(self):
        # Text area (shows buddy messages)
        self.txt_area = etk.Label()
        self.txt_area.text = '<br>Nullclient-Ecore<br> '

        # Appending text area to VBox
        vbox = etk.VBox()
        vbox.append(self.txt_area, etk.VBox.START, etk.VBox.EXPAND_FILL, 0)
        return vbox

    def __create_main_panel(self):
        # Text box
        txt_vbox = self.__create_text_area()

        # Buddies list
        bdd_vbox = self.__create_buddies_list()

        # Accounts list
        acc_vbox = self.__create_accounts_list()

        # Appending text area, buddies list and accounts list to HBox
        hbox = etk.HBox()
        hbox.append(txt_vbox, etk.HBox.START, etk.HBox.EXPAND_FILL, 0)
        hbox.append(bdd_vbox, etk.HBox.END, etk.HBox.EXPAND_FILL, 0)
        hbox.append(acc_vbox, etk.HBox.END, etk.HBox.EXPAND_FILL, 0)
        return hbox

    def __create_main_box(self):
        # Main panel
        panel_hbox = self.__create_main_panel()

        # Command entry
        cmd_hbox = self.__create_command_entry_box()

        # Buttons Bar
        btn_hbox = self.__create_buttons_bar()

        # Connection status
        self.status = etk.Label(text='Connection status')

        # Main VBox
        vbox = etk.VBox(homogeneous=False)
        vbox.append(panel_hbox, etk.VBox.START, etk.VBox.EXPAND_FILL, 0)
        vbox.append(cmd_hbox, etk.VBox.END, etk.VBox.FILL, 0)
        vbox.append(btn_hbox, etk.VBox.END, etk.VBox.NONE, 5)
        vbox.append(self.status, etk.VBox.END, etk.VBox.FILL, 0)
        return vbox

    def get_selected_account(self):
        # Catch selected account from accounts list
        try:
            account = self.accslist.selected_rows[0][0]
            if account:
                return account
            else:
                return None
        except:
            return None

    def add_buddy(self, name):
        # Adds a new buddy into buddy list
        if [name] not in self.blistmodel.elements:
            self.blistmodel.append([name])

    def remove_buddy(self, name):
        # Removes a buddy from buddy list
        self.blistmodel.remove([name])

    def add_account(self, pointer):
        # Adds a new account into accounts list
        if [self.login_username.text] not in self.accslistmodel.elements:
            self.accslistmodel.append([self.login_username.text])
        self.username_window.destroy()
        self.window.show_all()

    def add_connection_button_cb(self, cb):
        if callable(cb):
            self.__connect_button_cb = cb

    def add_new_account_cb(self, cb):
        if callable(cb):
            self.__new_account_cb = cb

    def add_send_button_cb(self, cb):
        if callable(cb):
            self.__send_button_cb = cb

    def add_exit_cb(self, cb):
        if callable(cb):
            self.__exit_cb = cb

    def init_window(self):
        # Main box
        main_box = self.__create_main_box()

        # Main Window
        self.window = etk.Window(title='Nullclient-Ecore', \
                size_request=(600, 600), child=main_box)
        self.window.on_destroyed(self.__exit_cb)
        self.window.show_all()

    def show(self):
        if self.window:
            self.window.show_all()

class NullClient(object):
    def __init__(self):
        # Sets initial parameters
        self.core = purple.Purple(__NAME__, __VERSION__, __WEBSITE__, \
                __DEV_WEBSITE__, debug_enabled=True, default_path='/tmp')
        self.account = None
        self.buddies = {}
        self.conversations = {}
        self.protocol = purple.Protocol('prpl-jabber')
        self.window = MainWindow()

        # Adds libpurple core callbacks

        # Updates buddy list
        self.core.add_callback('blist', 'update', \
                self.__update_blist_cb)

        # Updates connection progress
        self.core.add_callback('connection', 'connect-progress', \
                self.__connection_progress_cb)

        # Activates when an account is connected
        self.core.add_callback('connection', 'connected', \
                self.__connected_cb)

        # Activates when an account is disconnected
        self.core.add_callback('connection', 'disconnected', \
                self.__disconected_cb)

        # Activates when a message is sent or received from conversation
        self.core.add_callback('conversation', 'write-im', \
                self.__write_im_cb)

        # Signal when account signed on
        self.core.signal_connect('signed-on', self.__signed_on_cb)

        # Signal when account signed off
        self.core.signal_connect('signed-off', self.__signed_off_cb)

        # Signal when buddy signed on
        self.core.signal_connect('buddy-signed-on', self.__buddy_signed_on_cb)

        # Signed when buddy signed off
        self.core.signal_connect('buddy-signed-off', self.__buddy_signed_off_cb)

        # Adds UI callbacks
        self.window.add_connection_button_cb(self.connect)
        self.window.add_send_button_cb(self.send_message)
        self.window.add_exit_cb(self.exit)

        # Initializes libpurple
        self.core.purple_init()

        # Initializes UI
        self.window.init_window()

    def __update_blist_cb(self, type, name=None, alias=None):
        if self.account and name and type == 2:
            if name not in self.buddies:
                self.buddies[name] = purple.Buddy(name, self.account)
            if self.buddies[name].online:
                self.window.add_buddy(name)

    def __connection_progress_cb(self, text, step, step_count):
        if self.window:
            self.window.status.text = text

    def __connected_cb(self, *data):
        if self.window:
            self.window.status.text = 'Connected'

    def __disconected_cb():
        if self.window:
            self.window.status.text = 'Disconnected'

    def __write_im_cb(self, username, name, alias, message, flags):
        if self.window:
            if 'SEND' == flags:
                self.window.txt_area.text += username + ": " + message + "<br> "
            elif alias:
                self.window.txt_area.text += alias + ": " + message + "<br> "
            else:
                self.window.txt_area.text += name + ": " + message + "<br> "
            self.window.show()

    def __signed_on_cb(self, username, protocol_id):
        if self.window:
            self.window.txt_area += 'Signed on: %s (%s)' % (username, protocol_id)
            self.window.show()

    def __signed_off_cb(self, username, protocol_id):
        if self.window:
            self.window.txt_area += 'Signed off: %s (%s)' % (username, protocol_id)
            self.window.show()

    def __buddy_signed_on_cb(self, name, alias):
        if self.window:
            self.window.txt_area += 'Buddy signed on: %s (%s)' % (name, alias)
            self.window.show()

    def __buddy_signed_off_cb(self, name, alias):
        if name in self.buddies:
            del self.buddies[name]

        if self.window:
            self.window.txt_area += 'Buddy signed off: %s (%s)' % (name, alias)
            self.window.remove_buddy(name)
            self.window.show()

    def connect(self, password):
        username = self.window.get_selected_account()
        if username and password:
            self.account = purple.Account(username, self.protocol, self.core)
            if not self.account.exists:
                self.account.new()
                info = {}
                info['connect_server'] = 'talk.google.com'
                info['port'] = '443'
                info['old_ssl'] = True
                self.account.set_protocol_options(info)

            self.account.set_password(password)
            self.account.set_enabled(True)

    def send_message(self, name, message):
        print name, message
        if name not in self.conversations:
            self.conversations[name] = purple.Conversation('IM', self.account, name)
            self.conversations[name].new()

        self.conversations[name].im_send(message)

    def exit(self, pointer):
        ecore.main_loop_quit()

if __name__ == '__main__':
    client = NullClient()

    # Initializes ecore mainloop
    ecore.main_loop_begin()
