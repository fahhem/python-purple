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

cimport glib

cdef extern from "libpurple/eventloop.h":
    ctypedef enum PurpleInputCondition:
        PURPLE_INPUT_READ
        PURPLE_INPUT_WRITE

    ctypedef void (*PurpleInputFunction) (glib.gpointer, glib.gint, \
            PurpleInputCondition)

    ctypedef struct PurpleEventLoopUiOps:
        glib.guint (*timeout_add) (glib.guint interval, \
                glib.GSourceFunc function, glib.gpointer data)
        glib.gboolean (*timeout_remove) (glib.guint handle)
        glib.guint (*input_add) (int fd, PurpleInputCondition cond, \
                PurpleInputFunction func, glib.gpointer user_data)
        glib.gboolean (*input_remove) (glib.guint handle)
        int (*input_get_error) (int fd, int *error)
        glib.guint (*timeout_add_seconds) (glib.guint interval, \
                glib.GSourceFunc function, glib.gpointer data)

    # Event Loop API
    glib.guint purple_timeout_add(glib.guint interval, \
            glib.GSourceFunc function, glib.gpointer data)
    glib.guint purple_timeout_add_seconds(glib.guint interval, \
            glib.GSourceFunc function, glib.gpointer data)
    glib.gboolean purple_timeout_remove(glib.guint handle)
    glib.guint purple_input_add(int fd, PurpleInputCondition cond, \
            PurpleInputFunction func, glib.gpointer user_data)
    glib.gboolean purple_input_remove(glib.guint handle)
    int purple_input_get_error(int fd, int *error)

    # UI Registration Functions
    void purple_eventloop_set_ui_ops(PurpleEventLoopUiOps *ops)
    PurpleEventLoopUiOps *purple_eventloop_get_ui_ops()
