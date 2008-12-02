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

cdef extern from *:
    ctypedef int volatile_gint "volatile int"

cdef extern from "glib.h":
    ctypedef void *gpointer
    ctypedef void *gconstpointer
    ctypedef int gint
    ctypedef unsigned int guint
    ctypedef unsigned long gulong
    ctypedef signed long long gint64
    ctypedef unsigned long long guint64
    ctypedef gint gboolean
    ctypedef gboolean (*GSourceFunc) (gpointer data)
    ctypedef unsigned int gsize
    ctypedef signed int gssize
    ctypedef char gchar
    ctypedef unsigned char guchar

    ctypedef void (*GCallback) ()
    ctypedef void (*GDestroyNotify) (gpointer)

    ctypedef guint GHashFunc (gconstpointer)
    ctypedef gboolean GEqualFunc (gconstpointer, gconstpointer)

    ctypedef struct GObject:
        pass

    ctypedef struct GHashNode:
        gpointer key
        gpointer value
        GHashNode *next
        guint key_hash

    ctypedef struct GHashTable:
        gint size
        gint nnodes
        GHashNode **nodes
        GHashFunc hash_func
        GEqualFunc key_equal_func
        volatile_gint ref_count
        int version
        GDestroyNotify key_destroy_func
        GDestroyNotify value_destroy_func

    ctypedef struct GMainContext:
        pass

    ctypedef struct GSList:
        gpointer data
        GSList *next

    ctypedef struct GList:
        gpointer data
        GList *next
        GList *prev

    void g_list_free (GList*)

    gboolean g_str_equal (gconstpointer, gconstpointer)
    guint g_str_hash (gconstpointer)

    GHashTable *g_hash_table_new (GHashFunc, GEqualFunc)
    void g_hash_table_destroy (GHashTable*)
    GList *g_hash_table_get_keys (GHashTable*)
    GList *g_hash_table_get_values (GHashTable*)
    void g_hash_table_insert (GHashTable*, gpointer, gpointer)
    gpointer g_hash_table_lookup (GHashTable*, gconstpointer)

    guint g_timeout_add(guint interval, GSourceFunc function, gpointer data)
    guint g_timeout_add_seconds(guint interval, GSourceFunc function, gpointer data)

    gboolean g_main_context_iteration (GMainContext *context, gboolean may_block)

    gboolean g_source_remove(guint tag)

    gchar *g_markup_escape_text (gchar *text, gssize length)
