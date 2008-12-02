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

cdef extern from "time.h":
    ctypedef long int time_t

cdef extern from "libpurple/core.h":
    ctypedef struct PurpleCoreUiOps:
        void (*ui_prefs_init) ()
        void (*debug_ui_init) ()
        void (*ui_init) ()
        void (*quit) ()
        GHashTable (*get_ui_info) ()

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
    void c_purple_plugins_add_search_path "purple_plugins_add_search_path" (const_char_ptr path)

cdef extern from "libpurple/prefs.h":
    void c_purple_prefs_rename "purple_prefs_rename" (const_char_ptr oldname, const_char_ptr newname)
    const_char_ptr c_purple_prefs_get_string "purple_prefs_get_string" (const_char_ptr name)
    gboolean c_purple_prefs_load "purple_prefs_load" ()

cdef extern from "libpurple/util.h":
    void c_purple_util_set_user_dir "purple_util_set_user_dir" (char *dir)

cdef extern from "c_purple.h":
     void set_uiops()
     guint glib_input_add(gint fd, PurpleInputCondition condition, PurpleInputFunction function, gpointer data)

cdef void ui_init():
    pass

class Purple(object):
    def __init__(self):
        cdef PurpleCoreUiOps c_core_ui_ops
        c_core_ui_ops.ui_prefs_init = NULL
        c_core_ui_ops.debug_ui_init = NULL
        c_core_ui_ops.ui_init = ui_init
        c_core_ui_ops.quit = NULL
        c_core_ui_ops.get_ui_info = NULL

        cdef PurpleEventLoopUiOps c_eventloop_ui_ops
        c_eventloop_ui_ops.timeout_add = g_timeout_add
        c_eventloop_ui_ops.timeout_remove = g_source_remove
        c_eventloop_ui_ops.input_add = glib_input_add
        c_eventloop_ui_ops.input_remove = g_source_remove
        c_eventloop_ui_ops.input_get_error = NULL
        c_eventloop_ui_ops.timeout_add_seconds = NULL

        self.DEFAULT_PATH = "/home/user/MyDocs/Carman"
        self.APP_NAME = "carman-purple-python"

        self.debug_set_enabled(True)
        self.util_set_user_dir(self.DEFAULT_PATH)
        self.plugin_add_search_path(self.DEFAULT_PATH)

        c_purple_core_set_ui_ops(&c_core_ui_ops)
        c_purple_eventloop_set_ui_ops(&c_eventloop_ui_ops)

        ret = self.core_init(self.APP_NAME)
        if ret is False:
            self.debug_info("main", "Exiting because libpurple initialization failed.")
            return

        # check if there is another instance of libpurple running
        if self.core_ensure_single_instance() == False:
            self.debug_info("main", "Exiting because another instance of libpurple is already running.")
            self.core_quit()
            return
    # __init__

    def __del__(self):
        self.core_quit()
    # __del__

    def core_ensure_single_instance(self):
        return c_purple_core_ensure_single_instance()
    # core_ensure_single_instance

    def core_init(self, ui_name):
        return c_purple_core_init(ui_name)
    # core_init

    def core_quit(self):
        c_purple_core_quit()
    # core_quit

    def debug_misc(self, category, format):
        if category == None:
            c_purple_debug(PURPLE_DEBUG_MISC, NULL, format)
        else:
            c_purple_debug(PURPLE_DEBUG_MISC, category, format)
    # debug_misc

    def debug_info(self, category, format):
        if category == None:
            c_purple_debug(PURPLE_DEBUG_INFO, NULL, format)
        else:
            c_purple_debug(PURPLE_DEBUG_INFO, category, format)
    # debug_info

    def debug_warning(self, category, format):
        if category == None:
            c_purple_debug(PURPLE_DEBUG_WARNING, NULL, format)
        else:
            c_purple_debug(PURPLE_DEBUG_WARNING, category, format)
    # debug_warning

    def debug_error(self, category, format):
        if category == None:
            c_purple_debug(PURPLE_DEBUG_ERROR, NULL, format)
        else:
            c_purple_debug(PURPLE_DEBUG_ERROR, category, format)
    # debug_error

    def debug_fatal(self, category, format):
        if category == None:
            c_purple_debug(PURPLE_DEBUG_FATAL, NULL, format)
        else:
            c_purple_debug(PURPLE_DEBUG_FATAL, category, format)
    # debug_fatal

    def debug_set_enabled(self, debug_enabled):
        c_purple_debug_set_enabled(debug_enabled)
    # debug_set_enabled

    def plugin_add_search_path(self, path):
        c_purple_plugins_add_search_path(path)
    # plugin_add_search_path

    def prefs_rename(self, old_name, new_name):
        c_purple_prefs_rename(old_name, new_name)
    # prefs_rename

    def prefs_get_string(self, name):
        return c_purple_prefs_get_string(name)
    # prefs_get_string

    def prefs_load(self):
        return c_purple_prefs_load()
    # prefs_load

    def util_set_user_dir(self, dir):
        c_purple_util_set_user_dir(dir)
    # util_set_user_dir

include "core/account.pxd"
include "core/buddy.pxd"
#include "core/blist.pxd"
#include "core/connection.pxd"
#include "core/core.pxd"
#include "core/idle.pxd"
#include "core/pounce.pxd"
