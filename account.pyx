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
    cdef ProxyInfo __proxy

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

    def get_protocol_name(self):
        if self.c_account:
            return account.c_purple_account_get_protocol_name(self.c_account)
        else:
            return None

    def get_enabled(self, ui):
        if self.c_account:
            return account.c_purple_account_get_enabled(self.c_account, ui)
        else:
            return None

    def set_enabled(self, ui, value):
        if self.c_account:
            account.c_purple_account_set_enabled(self.c_account, ui, value)

    def set_status(self):
        self.__sstatus = savedstatuses.c_purple_savedstatus_new(NULL, status.PURPLE_STATUS_AVAILABLE)
        savedstatuses.c_purple_savedstatus_activate(self.__sstatus)

    def __get_proxy(self):
        return self.__proxy
    proxy = property(__get_proxy)

    def get_buddies_online(self):
        cdef glib.GSList *iter
        cdef blist.PurpleBuddy *buddy
        buddies = []
        iter = blist.c_purple_find_buddies(self.c_account, NULL)
        while iter:
            buddy = <blist.PurpleBuddy *> iter.data
            if <blist.PurpleBuddy *>buddy and \
                account.c_purple_account_is_connected(blist.c_purple_buddy_get_account(buddy)) and \
                status.c_purple_presence_is_online(blist.c_purple_buddy_get_presence(buddy)):
                buddies += [buddy.name]
            iter = iter.next
        return buddies

    def get_protocol_options(self):
        ''' FIXME: It is just a hack, to set the XMPP's options. '''
        cdef glib.GList *iter
        cdef accountopt.PurpleAccountOption *option
        cdef prefs.PurplePrefType type
        cdef const_char *label_name
        cdef const_char *str_value
        cdef const_char *setting
        cdef int int_value
        cdef glib.gboolean bool_value
        iter = self.c_prpl_info.protocol_options
        while iter:
            option = <accountopt.PurpleAccountOption *> iter.data
            type = accountopt.c_purple_account_option_get_type(option)
            label_name = accountopt.c_purple_account_option_get_text(option)
            setting = accountopt.c_purple_account_option_get_setting(option)
            if type == prefs.PURPLE_PREF_STRING:
                str_value = accountopt.c_purple_account_option_get_default_string(option)

                # Google Talk default domain hackery!
                if str_value == NULL and str(<char *> label_name) == "Connect server":
                    str_value = "talk.google.com"

                if self.c_account != NULL:
                    str_value = account.c_purple_account_get_string(self.c_account, setting, str_value)
                    account.c_purple_account_set_string(self.c_account, setting, str_value)

            elif type == prefs.PURPLE_PREF_INT:
                int_value = accountopt.c_purple_account_option_get_default_int(option)
                if self.c_account != NULL:
                   int_value = account.c_purple_account_get_int(self.c_account, setting, int_value)
                   if str(<char *> setting) == "port":
                        account.c_purple_account_set_int(self.c_account, setting, 443)

            elif type == prefs.PURPLE_PREF_BOOLEAN:
                bool_value = accountopt.c_purple_account_option_get_default_bool(option)
                if self.c_account != NULL:
                    bool_value = account.c_purple_account_get_bool(self.c_account, setting, bool_value)
                    if str(<char *> setting) == "old_ssl":
                        account.c_purple_account_set_bool(self.c_account, setting, True)

            elif type == prefs.PURPLE_PREF_STRING_LIST:
                str_value = accountopt.c_purple_account_option_get_default_list_value(option)
                if self.c_account != NULL:
                    str_value = account.c_purple_account_get_string(self.c_account, setting, str_value)

            iter = iter.next

    def save_into_xml(self):
        account.c_purple_accounts_add(self.c_account)
