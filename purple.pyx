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

import ecore

cdef extern from *:
    ctypedef char* const_char_ptr "const char *"

cdef extern from "time.h":
    ctypedef long int time_t

cdef extern from "libpurple/blist.h":
    ctypedef struct PurpleBuddyList:
        pass

    void c_purple_set_blist "purple_set_blist" (PurpleBuddyList *list)
    void c_purple_blist_load "purple_blist_load" ()
    PurpleBuddyList* c_purple_blist_new "purple_blist_new" ()

cdef extern from "libpurple/core.h":
    ctypedef struct PurpleCoreUiOps:
        void (*ui_prefs_init) ()
        void (*debug_ui_init) ()
        void (*ui_init) ()
        void (*quit) ()
        GHashTable* (*get_ui_info) ()

    gboolean c_purple_core_init "purple_core_init" (const_char_ptr ui_name)
    void c_purple_core_quit "purple_core_quit" ()
    void c_purple_core_set_ui_ops "purple_core_set_ui_ops" (PurpleCoreUiOps *ops)
    gboolean c_purple_core_ensure_single_instance "purple_core_ensure_single_instance" ()

cdef extern from "libpurple/debug.h":
    ctypedef enum PurpleDebugLevel:
        PURPLE_DEBUG_ALL
        PURPLE_DEBUG_MISC
        PURPLE_DEBUG_INFO
        PURPLE_DEBUG_WARNING
        PURPLE_DEBUG_ERROR
        PURPLE_DEBUG_FATAL

    void c_purple_debug "purple_debug" (PurpleDebugLevel level, const_char_ptr category, const_char_ptr format)
    void c_purple_debug_set_enabled "purple_debug_set_enabled" (gboolean debug_enabled)

cdef extern from "libpurple/eventloop.h":
    ctypedef enum PurpleInputCondition:
        PURPLE_INPUT_READ
        PURPLE_INPUT_WRITE

    ctypedef void (*PurpleInputFunction) (gpointer , gint, PurpleInputCondition)

    ctypedef struct PurpleEventLoopUiOps:
        guint (*timeout_add) (guint interval, GSourceFunc function, gpointer data)
        gboolean (*timeout_remove) (guint handle)
        guint (*input_add) (int fd, PurpleInputCondition cond, PurpleInputFunction func, gpointer user_data)
        gboolean (*input_remove) (guint handle)
        int (*input_get_error) (int fd, int *error)
        guint (*timeout_add_seconds)(guint interval, GSourceFunc function, gpointer data)

    void c_purple_eventloop_set_ui_ops "purple_eventloop_set_ui_ops" (PurpleEventLoopUiOps *ops)

cdef extern from "libpurple/plugin.h":
    ctypedef struct PurplePlugin

    cdef struct _PurplePluginInfo:
        char *id
        char *name
    ctypedef _PurplePluginInfo PurplePluginInfo

    cdef struct _PurplePlugin:
        PurplePluginInfo *info                # The plugin information.
    ctypedef _PurplePlugin PurplePlugin

    void c_purple_plugins_add_search_path "purple_plugins_add_search_path" (const_char_ptr path)
    GList *c_purple_plugins_get_protocols "purple_plugins_get_protocols" ()

cdef extern from "libpurple/pounce.h":
    gboolean c_purple_pounces_load "purple_pounces_load" ()

cdef extern from "libpurple/prefs.h":
    void c_purple_prefs_add_none "purple_prefs_add_none" (const_char_ptr name)
    void c_purple_prefs_rename "purple_prefs_rename" (const_char_ptr oldname, const_char_ptr newname)
    const_char_ptr c_purple_prefs_get_string "purple_prefs_get_string" (const_char_ptr name)
    gboolean c_purple_prefs_load "purple_prefs_load" ()

cdef extern from "libpurple/util.h":
    void c_purple_util_set_user_dir "purple_util_set_user_dir" (char *dir)

cdef extern from "c_purple.h":
     guint glib_input_add(gint fd, PurpleInputCondition condition, PurpleInputFunction function, gpointer data)
     void glib_main_loop()

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
    # core_init

# Purple

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

    def connect(self):
        conn = Connection()
        conn.connect()

    def run_loop(self):
        glib_main_loop()

include "core/account.pxd"
include "core/buddy.pxd"
include "glib.pxd"
#include "core/blist.pxd"
include "core/connection.pxd"
#include "core/core.pxd"
#include "core/idle.pxd"
