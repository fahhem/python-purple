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

cdef extern from "c_purple.h":
    glib.guint glib_input_add(glib.gint fd, eventloop.PurpleInputCondition condition, eventloop.PurpleInputFunction function, glib.gpointer data)

import ecore

__DEFAULT_PATH__ = "/tmp"
__APP_NAME__ = "carman-purple-python"
__APP_VERSION__ = "0.1"

cdef class Purple:
    """ Purple class.

    @parm debug_enabled: Toggle debug messages.
    @parm app_name: Set application name.
    @parm default_path: Full path for libpurple user files.
    """

    cdef core.PurpleCoreUiOps c_core_ui_ops
    cdef eventloop.PurpleEventLoopUiOps c_eventloop_ui_ops
    cdef glib.GHashTable *c_ui_info

    def __init__(self, debug_enabled=True, app_name=__APP_NAME__, default_path=__DEFAULT_PATH__):
        self.c_ui_info = NULL

        if app_name is not __APP_NAME__:
            __APP_NAME__ = app_name

        if default_path is not __DEFAULT_PATH__:
            __DEFAULT_PATH__ = default_path

        debug.c_purple_debug_set_enabled(debug_enabled)
        util.c_purple_util_set_user_dir(default_path)
        plugin.c_purple_plugins_add_search_path(default_path)

        # adds glib iteration inside ecore main loop
        ecore.idler_add(self.__glib_iteration_when_idle)

    def __del__(self):
        core.c_purple_core_quit()

    cdef void __core_ui_ops_ui_prefs_init(self):
        debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "core_ui_ops", "ui_prefs_init\n")
        prefs.c_purple_prefs_load()

        prefs.c_purple_prefs_add_none("/carman")

    cdef void __core_ui_ops_debug_init(self):
        debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "core_ui_ops", "debug_ui_init\n")

    cdef void __core_ui_ops_ui_init(self):
        debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "core_ui_ops", "ui_init\n")

        # FIXME: Add core ui initialization here

    cdef void __core_ui_ops_quit(self):
        debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "core_ui_ops", "quit\n")

        account.c_purple_accounts_set_ui_ops(NULL)
        connection.c_purple_connections_set_ui_ops(NULL)
        blist.c_purple_blist_set_ui_ops(NULL)
        conversation.c_purple_conversations_set_ui_ops(NULL)
        notify.c_purple_notify_set_ui_ops(NULL)
        request.c_purple_request_set_ui_ops(NULL)
        ft.c_purple_xfers_set_ui_ops(NULL)
        roomlist.c_purple_roomlist_set_ui_ops(NULL)

        if self.c_ui_info:
            glib.g_hash_table_destroy(self.c_ui_info)

    cdef glib.GHashTable *__core_ui_ops_get_ui_info(self):
        if self.c_ui_info == NULL:
            self.c_ui_info = glib.g_hash_table_new(glib.g_str_hash, glib.g_str_equal)

            glib.g_hash_table_insert(self.c_ui_info, "name", <glib.gpointer> __APP_NAME__)
            glib.g_hash_table_insert(self.c_ui_info, "version", <glib.gpointer> __APP_VERSION__)
        return self.c_ui_info

    def __glib_iteration_when_idle(self):
        glib.g_main_context_iteration(NULL, False)
        return True

    def purple_init(self):
        """ Initializes libpurple """
        # initialize c_core_ui_ops structure
        self.c_core_ui_ops.ui_prefs_init = <void (*)()> self.__core_ui_ops_ui_prefs_init
        self.c_core_ui_ops.debug_ui_init = <void (*)()> self.__core_ui_ops_debug_init
        self.c_core_ui_ops.ui_init = <void (*)()> self.__core_ui_ops_ui_init
        self.c_core_ui_ops.quit = <void (*)()> self.__core_ui_ops_quit
        self.c_core_ui_ops.get_ui_info = <glib.GHashTable* (*)()> self.__core_ui_ops_get_ui_info

        core.c_purple_core_set_ui_ops(&self.c_core_ui_ops)

        # initialize c_eventloop_ui_ops structure
        self.c_eventloop_ui_ops.timeout_add = glib.g_timeout_add
        self.c_eventloop_ui_ops.timeout_remove = glib.g_source_remove
        self.c_eventloop_ui_ops.input_add = glib_input_add
        self.c_eventloop_ui_ops.input_remove = glib.g_source_remove
        self.c_eventloop_ui_ops.input_get_error = NULL
        self.c_eventloop_ui_ops.timeout_add_seconds = glib.g_timeout_add_seconds

        eventloop.c_purple_eventloop_set_ui_ops(&self.c_eventloop_ui_ops)

        # initialize purple core
        ret = core.c_purple_core_init(__APP_NAME__)
        if ret is False:
            debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "main", "Exiting because libpurple initialization failed.\n")
            return False

        # check if there is another instance of libpurple running
        if core.c_purple_core_ensure_single_instance() == False:
            debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "main", "Exiting because another instance of libpurple is already running.\n")
            core.c_purple_core_quit()
            return False

        # create and load the buddy list
        blist.c_purple_set_blist(blist.c_purple_blist_new())
        blist.c_purple_blist_load()

        # load pounces
        pounce.c_purple_pounces_load()

        return ret

    def get_protocols(self):
        cdef glib.GList *iter
        cdef plugin.PurplePlugin *__plugin
        protocols = []
        iter = plugin.c_purple_plugins_get_protocols()
        while iter:
            __plugin = <plugin.PurplePlugin*> iter.data
            if __plugin.info and __plugin.info.name:
                protocols += [(__plugin.info.id, __plugin.info.name)]
            iter = iter.next
        return protocols

    def connect(self):
        conn = Connection()
        conn.connect()

include "proxy.pyx"
include "account.pyx"
include "buddy.pyx"
include "connection.pyx"
include "conversation.pyx"
