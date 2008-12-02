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

include "glib.pxd"

cdef extern from *:
    ctypedef char* const_char_ptr "const char *"
    ctypedef char* const_guchar_ptr "const guchar *"

cdef extern from "time.h":
    ctypedef long int time_t

include "libpurple/account.pxd"
include "libpurple/buddyicon.pxd"
include "libpurple/blist.pxd"
include "libpurple/connection.pxd"
include "libpurple/conversation.pxd"
include "libpurple/core.pxd"
include "libpurple/debug.pxd"
include "libpurple/eventloop.pxd"
include "libpurple/idle.pxd"
include "libpurple/plugin.pxd"
include "libpurple/pounce.pxd"
include "libpurple/prefs.pxd"
include "libpurple/proxy.pxd"
include "libpurple/signals.pxd"
include "libpurple/status.pxd"
include "libpurple/savedstatuses.pxd"
include "libpurple/util.pxd"

cdef extern from "c_purple.h":
    void connect_to_signals_for_demonstration_purposes_only ()
    guint glib_input_add(gint fd, PurpleInputCondition condition, PurpleInputFunction function, gpointer data)

import ecore

__DEFAULT_PATH__ = "/tmp"
__APP_NAME__ = "carman-purple-python"
__APP_VERSION__ = "0.1"

global __DEFAULT_PATH__
global __APP_NAME__
global __APP_VERSION__

cdef class Purple:
    """ Purple class """
    cdef PurpleCoreUiOps c_core_ui_ops
    cdef PurpleEventLoopUiOps c_eventloop_ui_ops
    cdef GHashTable *c_ui_info

    def __cinit__(self, debug_enabled=True, app_name=__APP_NAME__, default_path=__DEFAULT_PATH__):
        self.c_ui_info = NULL

        if app_name is not __APP_NAME__:
            __APP_NAME__ = app_name

        if default_path is not __DEFAULT_PATH__:
            __DEFAULT_PATH__ = default_path

        c_purple_debug_set_enabled(debug_enabled)
        c_purple_util_set_user_dir(default_path)
        c_purple_plugins_add_search_path(default_path)

        # adds glib iteration inside ecore main loop
        ecore.idler_add(self.__glib_iteration_when_idle)
     # __cinit__

    def __del__(self):
        c_purple_core_quit()
    # __del__

    cdef void __core_ui_ops_ui_prefs_init(self):
        c_purple_debug(PURPLE_DEBUG_INFO, "core_ui_ops", "ui_prefs_init\n")
        c_purple_prefs_load()

        c_purple_prefs_add_none("/carman")
        c_purple_prefs_add_none("/carman/plugins")
    # __core_ui_ops_ui_prefs_init

    cdef void __core_ui_ops_debug_init(self):
        c_purple_debug(PURPLE_DEBUG_INFO, "core_ui_ops", "debug_ui_init\n")
    # __core_ui_ops_debug_init

    cdef void __core_ui_ops_ui_init(self):
        c_purple_debug(PURPLE_DEBUG_INFO, "core_ui_ops", "ui_init\n")
    # __core_ui_ops_ui_init

    cdef void __core_ui_ops_quit(self):
        c_purple_debug(PURPLE_DEBUG_INFO, "core_ui_ops", "quit\n")
    # __core_ui_ops_quit

    cdef GHashTable *__core_ui_ops_get_ui_info(self):
        if self.c_ui_info == NULL:
            self.c_ui_info = g_hash_table_new(g_str_hash, g_str_equal)

            g_hash_table_insert(self.c_ui_info, "name", <gpointer> __APP_NAME__)
            g_hash_table_insert(self.c_ui_info, "version", <gpointer> __APP_VERSION__)
        return self.c_ui_info
    # __core_ui_ops_get_ui_info

    def __glib_iteration_when_idle(self):
        g_main_context_iteration(NULL, False)
        return True
    # __glib_iteration_when_idle

    def purple_init(self):
        """ Initializes libpurple """
        # initialize c_core_ui_ops structure
        self.c_core_ui_ops.ui_prefs_init = <void (*)()> self.__core_ui_ops_ui_prefs_init
        self.c_core_ui_ops.debug_ui_init = <void (*)()> self.__core_ui_ops_debug_init
        self.c_core_ui_ops.ui_init = <void (*)()> self.__core_ui_ops_ui_init
        self.c_core_ui_ops.quit = <void (*)()> self.__core_ui_ops_quit
        self.c_core_ui_ops.get_ui_info = <GHashTable* (*)()> self.__core_ui_ops_get_ui_info

        c_purple_core_set_ui_ops(&self.c_core_ui_ops)

        # initialize c_eventloop_ui_ops structure
        self.c_eventloop_ui_ops.timeout_add = g_timeout_add
        self.c_eventloop_ui_ops.timeout_remove = g_source_remove
        self.c_eventloop_ui_ops.input_add = glib_input_add
        self.c_eventloop_ui_ops.input_remove = g_source_remove
        self.c_eventloop_ui_ops.input_get_error = NULL
        self.c_eventloop_ui_ops.timeout_add_seconds = g_timeout_add_seconds

        c_purple_eventloop_set_ui_ops(&self.c_eventloop_ui_ops)

        # initialize purple core
        ret = c_purple_core_init(__APP_NAME__)
        if ret is False:
            c_purple_debug(PURPLE_DEBUG_INFO, "main", "Exiting because libpurple initialization failed.\n")
            return False

        # check if there is another instance of libpurple running
        if c_purple_core_ensure_single_instance() == False:
            c_purple_debug(PURPLE_DEBUG_INFO, "main", "Exiting because another instance of libpurple is already running.\n")
            c_purple_core_quit()
            return False

        # create and load the buddy list
        c_purple_set_blist(c_purple_blist_new())
        c_purple_blist_load()

        # load pounces
        c_purple_pounces_load()

        return ret
    # purple_init

    def get_protocols(self):
        cdef GList *iter
        cdef PurplePlugin *plugin
        protocols = []
        iter = c_purple_plugins_get_protocols()
        while iter:
            plugin = <PurplePlugin*> iter.data
            if plugin.info and plugin.info.name:
                protocols += [(plugin.info.id, plugin.info.name)]
            iter = iter.next
        return protocols
    # get_protocols

    def connect(self):
        conn = Connection()
        conn.connect()
    # connect
# Purple

include "account.pxd"
include "buddy.pxd"
include "connection.pxd"
include "conversation.pxd"
