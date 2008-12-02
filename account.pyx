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

cimport purple

cdef extern from *:
    ctypedef char const_char "const char"

cdef class Account:
    """ Account class """
    cdef account.PurpleAccount *c_account
    cdef plugin.PurplePlugin *c_plugin
    cdef prpl.PurplePluginProtocolInfo *c_prpl_info
    cdef plugin.PurplePluginInfo *c_plugin_info
    cdef savedstatuses.PurpleSavedStatus *__sstatus

    cdef object __proxy
    cdef object __protocol

    def __init__(self):
        self.__proxy = purple.ProxyInfo()
        self.__protocol = purple.Plugin()

    '''
    def __init__(self, char *username, char *protocol_id):
        cdef proxy.PurpleProxyInfo *c_proxyinfo
        cdef account.PurpleAccount *acc = NULL

        acc = account.c_purple_accounts_find(username, protocol_id)
        if acc:
            self.c_account = acc
            c_proxyinfo = account.c_purple_account_get_proxy_info(self.c_account)
        else:
            self.c_account = account.c_purple_account_new(username, protocol_id)
            c_proxyinfo = account.c_purple_account_get_proxy_info(self.c_account)
            if c_proxyinfo == NULL:
                c_proxyinfo = proxy.c_purple_proxy_info_new()
                proxy.c_purple_proxy_info_set_type(c_proxyinfo, proxy.PURPLE_PROXY_NONE)
                account.c_purple_account_set_proxy_info(self.c_account, c_proxyinfo)
        self.__proxy = ProxyInfo()
        self.__proxy.c_proxyinfo = c_proxyinfo
        acc = NULL

        self.c_plugin = plugin.c_purple_plugins_find_with_id(protocol_id)
        self.c_prpl_info = plugin.c_PURPLE_PLUGIN_PROTOCOL_INFO(self.c_plugin)
    '''

    def __get_username(self):
        if self.c_account:
            return account.c_purple_account_get_username(self.c_account)
        else:
            return None
    def __set_username(self, username):
        if self.c_account:
            account.c_purple_account_set_username(self.c_account, username)
    username = property(__get_password, __set_username)

    def __get_password(self):
        if self.c_account:
            return account.c_purple_account_get_password(self.c_account)
        else:
            return None
    def __set_password(self, password):
        if self.c_account:
            account.c_purple_account_set_password(self.c_account, password)
    password = property(__get_password, __set_password)

    def __get_alias(self):
        if self.c_account:
            return account.c_purple_account_get_alias(self.c_account)
        else:
            return None
    def __set_alias(self, alias):
        if self.c_account:
            account.c_purple_account_set_alias(self.c_account, alias)
    alias = property(__get_alias, __set_alias)

    def __get_user_info(self):
        if self.c_account:
            return account.c_purple_account_get_user_info(self.c_account)
        else:
            return None
    def __set_user_info(self, user_info):
        if self.c_account:
            account.c_purple_account_set_user_info(self.c_account, user_info)
    user_info = property(__get_user_info, __set_user_info)

    def __get_protocol_id(self):
        if self.c_account:
            return account.c_purple_account_get_protocol_id(self.c_account)
        else:
            return None
    def __set_protocol_id(self, protocol_id):
        if self.c_account:
            account.c_purple_account_set_protocol_id(self.c_account, protocol_id)
    protocol_id = property(__get_protocol_id, __set_protocol_id)

    def __get_remember_password(self):
        if self.c_account:
            return account.c_purple_account_get_remember_password(self.c_account)
        else:
            return None
    def __set_remember_password(self, value):
        if self.c_account:
            account.c_purple_account_set_remember_password(self.c_account, value)
    remember_password = property(__get_remember_password, __set_remember_password)

    def _get_protocol_options(self):
        cdef glib.GList *iter
        cdef accountopt.PurpleAccountOption *option
        cdef prefs.PurplePrefType type
        cdef const_char *label_name
        cdef const_char *str_value
        cdef const_char *setting
        cdef int int_value
        cdef glib.gboolean bool_value

        if self.c_account == NULL:
            return None

        po = {}

        iter = self.c_prpl_info.protocol_options

        while iter:

            option = <accountopt.PurpleAccountOption *> iter.data
            type = accountopt.c_purple_account_option_get_type(option)
            label_name = accountopt.c_purple_account_option_get_text(option)
            setting = accountopt.c_purple_account_option_get_setting(option)

            sett = str(<char *> setting)

            if type == prefs.PURPLE_PREF_STRING:

                str_value = accountopt.c_purple_account_option_get_default_string(option)

                # Google Talk default domain hackery!
                if str_value == NULL and str(<char *> label_name) == "Connect server":
                    str_value = "talk.google.com"
                str_value = account.c_purple_account_get_string(self.c_account, setting, str_value)

                val = str(<char *> str_value)

            elif type == prefs.PURPLE_PREF_INT:

                int_value = accountopt.c_purple_account_option_get_default_int(option)
                int_value = account.c_purple_account_get_int(self.c_account, setting, int_value)

                val = int(int_value)

            elif type == prefs.PURPLE_PREF_BOOLEAN:

                bool_value = accountopt.c_purple_account_option_get_default_bool(option)
                bool_value = account.c_purple_account_get_bool(self.c_account, setting, bool_value)

                val = bool(bool_value)

            elif type == prefs.PURPLE_PREF_STRING_LIST:

                str_value = accountopt.c_purple_account_option_get_default_list_value(option)
                str_value = account.c_purple_account_get_string(self.c_account, setting, str_value)

                val = str(<char *> str_value)

            iter = iter.next

            po[sett] = val

        return po

    def _set_protocol_options(self, po):
        cdef glib.GList *iter
        cdef accountopt.PurpleAccountOption *option
        cdef prefs.PurplePrefType type
        cdef const_char *str_value
        cdef const_char *setting
        cdef int int_value
        cdef glib.gboolean bool_value

        if self.c_account == NULL:
            return

        po = {}

        iter = self.c_prpl_info.protocol_options

        while iter:

            option = <accountopt.PurpleAccountOption *> iter.data
            type = accountopt.c_purple_account_option_get_type(option)
            setting = accountopt.c_purple_account_option_get_setting(option)

            sett = str(<char *> setting)

            if type == prefs.PURPLE_PREF_STRING:

                str_value = <char *> po[sett]
                account.c_purple_account_set_string(self.c_account, setting, str_value)

            elif type == prefs.PURPLE_PREF_INT:

                int_value = int(po[sett])
                account.c_purple_account_set_int(self.c_account, setting, int_value)

            elif type == prefs.PURPLE_PREF_BOOLEAN:

                bool_value = bool(po[sett])
                account.c_purple_account_set_bool(self.c_account, setting, bool_value)

            elif type == prefs.PURPLE_PREF_STRING_LIST:

                str_value = <char *> po[sett]
                account.c_purple_account_set_string(self.c_account, setting, str_value)

            iter = iter.next

    protocol_options = property(_get_protocol_options, _set_protocol_options)

    def _get_protocol_labels(self):
        cdef glib.GList *iter
        cdef accountopt.PurpleAccountOption *option
        cdef const_char *label_name
        cdef const_char *setting

        if self.c_account == NULL:
            return None

        po = {}

        iter = self.c_prpl_info.protocol_options

        while iter:

            option = <accountopt.PurpleAccountOption *> iter.data
            label_name = accountopt.c_purple_account_option_get_text(option)
            setting = accountopt.c_purple_account_option_get_setting(option)

            sett = str(<char *> setting)
            label = str(<char *> label_name)

            po[sett] = label

        return po

    protocol_labels = property(_get_protocol_labels)

    def __get_proxy(self):
        return self.__proxy
    proxy = property(__get_proxy)

    def __get_protocol(self):
        return self.__protocol
    protocol = property(__get_protocol)

    def get_protocol_name(self):
        if self.c_account:
            return account.c_purple_account_get_protocol_name(self.c_account)
        else:
            return None

    def set_status(self):
        self.__sstatus = savedstatuses.c_purple_savedstatus_new(NULL, status.PURPLE_STATUS_AVAILABLE)
        savedstatuses.c_purple_savedstatus_activate(self.__sstatus)

    def get_buddies_online(self, acc):
        cdef account.PurpleAccount *c_account
        cdef glib.GSList *iter
        cdef blist.PurpleBuddy *buddy
        cdef char *c_name = NULL
        cdef char *c_alias = NULL

        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            iter = blist.c_purple_find_buddies(c_account, NULL)
        else:
            return None

        buddies = []
        while iter:
            c_name = NULL
            c_alias = NULL
            buddy = <blist.PurpleBuddy *> iter.data
            if <blist.PurpleBuddy *>buddy and \
                account.c_purple_account_is_connected(blist.c_purple_buddy_get_account(buddy)) and \
                status.c_purple_presence_is_online(blist.c_purple_buddy_get_presence(buddy)):
                c_name = <char *> blist.c_purple_buddy_get_name(buddy)
                if c_name == NULL:
                    name = None
                else:
                    name = c_name
                c_alias = <char *> blist.c_purple_buddy_get_alias_only(buddy)
                if c_alias == NULL:
                    alias = None
                else:
                    alias = c_alias
                buddies.append((name, alias))
            iter = iter.next
        return buddies

    def new(self, username, protocol_id):
        cdef account.PurpleAccount *c_account
        c_account = account.c_purple_account_new(username, protocol_id)

        if c_account == NULL:
            return None

        account.c_purple_accounts_add(c_account) 

        return (username, protocol_id)

    def get_all(self):
        cdef glib.GList *iter
        cdef account.PurpleAccount *acc

        accounts = []

        iter = account.c_purple_accounts_get_all()
        while iter:
            acc = <account.PurpleAccount *> iter.data
            if <account.PurpleAccount *>acc:
                username = account.c_purple_account_get_username(acc)
                protocol_id = account.c_purple_account_get_protocol_id(acc)

                accounts.append((username, protocol_id))
            iter = iter.next

        return accounts

    def get_password(self, acc):
        ''' @param acc Tuple (username, protocol id) '''
        cdef account.PurpleAccount *c_account
        cdef char *value
        value = NULL

        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            value = <char *> account.c_purple_account_get_password(c_account)

        if value == NULL:
            return None
        else:
            return value


    def set_password(self, acc, password):
        ''' @param acc Tuple (username, protocol id) '''
        ''' @param password The account's password '''
        cdef account.PurpleAccount *c_account

        if not password:
            return

        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            account.c_purple_account_set_password(c_account, password)

    def get_alias(self, acc):
        ''' @param acc Tuple (username, protocol id) '''
        cdef account.PurpleAccount *c_account
        cdef char *value
        value = NULL

        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            value = <char *> account.c_purple_account_get_alias(c_account)

        if value == NULL:
            return None
        else:
            return value

    def set_alias(self, acc, alias):
        ''' @param acc Tuple (username, protocol id) '''
        ''' @param alias The account's alias '''
        cdef account.PurpleAccount *c_account

        if not alias:
            return

        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            account.c_purple_account_set_alias(c_account, alias)

    def set_protocol_id(self, acc, protocol_id):
        ''' @param acc Tuple (username, protocol id) '''
        ''' @param protocol_id The new account's protocol id '''
        cdef account.PurpleAccount *c_account

        if not protocol_id:
            return

        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            account.c_purple_account_set_protocol_id(c_account, protocol_id)

    def get_protocol_id(self, acc):
        ''' @param acc Tuple (username, protocol id) '''
        ''' @return account's protocol id '''
        cdef account.PurpleAccount *c_account
        cdef char *value
        value = NULL

        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            value = <char *> account.c_purple_account_get_protocol_id(c_account)

        if value == NULL:
            return None
        else:
            return value


    def set_enabled(self, acc, ui, value):
        ''' @param acc Tuple (username, protocol id) '''
        ''' @param ui The UI '''
        ''' @param value True to enabled or False to disabled '''
        cdef account.PurpleAccount *c_account

        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            account.c_purple_account_set_enabled(c_account, <char *> ui, bool(value))

    def get_enabled(self, acc, ui):
        ''' @param acc Tuple (username, protocol id) '''
        ''' @param ui The UI '''
        cdef account.PurpleAccount *c_account

        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            return account.c_purple_account_get_enabled(c_account, ui)
        else:
            return False

    def is_connected(self, acc):
        ''' @param acc Tuple (username, protocol id) '''
        ''' @param ui The UI '''
        cdef account.PurpleAccount *c_account

        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            return account.c_purple_account_is_connected(c_account)
        else:
            return False

    def connect(self, acc):
        ''' @param acc Tuple (username, protocol id) '''
        ''' @param ui The UI '''
        cdef account.PurpleAccount *c_account

        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            account.c_purple_account_connect(c_account)

    def disconnect(self, acc):
        ''' @param acc Tuple (username, protocol id) '''
        ''' @param ui The UI '''
        cdef account.PurpleAccount *c_account

        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            account.c_purple_account_disconnect(c_account)

    def set_remember_password(self, acc, value):
        cdef account.PurpleAccount *c_account
        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            account.c_purple_account_set_remember_password(c_account, value)

    def get_remember_password(self, acc):
        cdef account.PurpleAccount *c_account
        c_account = account.c_purple_accounts_find(acc[0], acc[1])
        if c_account:
            return account.c_purple_account_get_remember_password(c_account)
        else:
            return None
