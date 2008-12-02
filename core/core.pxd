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
#  but WITHOUT ANY WARRANTY = None without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

cdef extern from "libpurple/core.h":
    ctypedef struct PurpleCoreUiOps:
        void (*ui_prefs_init) ()
        void (*debug_ui_init) ()
        void (*ui_init) ()
        void (*quit) ()
        GHashTable* (*get_ui_info) ()

    cdef gboolean c_purple_core_init "purple_core_init" (const_char_ptr ui)
    cdef void c_purple_core_quit "purple_core_quit" ()
    cdef gboolean c_purple_core_migrate "purple_core_migrate" ()
    cdef void c_purple_core_set_ui_ops "purple_core_set_ui_ops" (PurpleCoreUiOps *ops)

""" CoreUiOps class """
__core_uiops = None

cdef void ui_prefs_init():
    global __core_uiops
    if __core_uiops and __core_uiops.ui_prefs_init:
        __core_uiops.ui_prefs_init()

cdef void debug_ui_init():
    global __core_uiops
    if __core_uiops and __core_uiops.debug_ui_init:
        __core_uiops.debug_ui_init()

cdef void ui_init():
    global __core_uiops
    if __core_uiops and __core_uiops.ui_init:
        __core_uiops.ui_init()

cdef void quit():
    global __core_uiops
    if __core_uiops and __core_uiops.quit:
        __core_uiops.quit()

cdef GHashTable *get_ui_info():
    global __core_uiops
    if __core_uiops and __core_uiops.get_ui_info:
        __core_uiops.get_ui_info()


class CoreUiOps(object):
    def __init__(self):
        self.ui_prefs_init = None
        self.debug_ui_init = None
        self.ui_init = None
        self.quit = None
        self.get_ui_info = None


def core_set_ui_ops(core_uiops):
    global __core_uiops
    cdef PurpleCoreUiOps c_core_uiops

    c_core_uiops.ui_prefs_init = ui_prefs_init
    c_core_uiops.debug_ui_init = debug_ui_init
    c_core_uiops.ui_init = ui_init
    c_core_uiops.quit = quit
    c_core_uiops.get_ui_info = get_ui_info

    __core_uiops = core_uiops

    c_purple_core_set_ui_ops(&c_core_uiops)

def core_init(ui):
    c_purple_core_init(ui)

