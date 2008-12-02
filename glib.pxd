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

cdef extern from "glib.h":
    ctypedef void *gpointer
    ctypedef void *gconstpointer
    ctypedef int gint
    ctypedef unsigned int guint
    ctypedef unsigned long gulong
    ctypedef gint gboolean
    ctypedef gboolean (*GSourceFunc) (gpointer data)

    ctypedef struct GHashTable:
        pass

    ctypedef struct GMainContext:
        pass

    struct _GSList:
        gpointer data
        _GSList *next
    ctypedef _GSList GSList

    struct _GList:
        gpointer data
        _GList *next
        _GList *prev
    ctypedef _GList GList

    ctypedef guint GHashFunc (gconstpointer)
    ctypedef gboolean GEqualFunc (gconstpointer, gconstpointer)

    gboolean g_str_equal (gconstpointer, gconstpointer)
    guint g_str_hash (gconstpointer)

    GHashTable *g_hash_table_new (GHashFunc, GEqualFunc)
    void g_hash_table_insert (GHashTable*, gpointer, gpointer)

    guint g_timeout_add(guint interval, GSourceFunc function, gpointer data)
    guint g_timeout_add_seconds(guint interval, GSourceFunc function, gpointer data)

    gboolean g_main_context_iteration (GMainContext *context, gboolean may_block)

    gboolean g_source_remove(guint tag)
