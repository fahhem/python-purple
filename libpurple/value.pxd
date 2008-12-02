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

cdef extern from "libpurple/value.h":
    ctypedef enum PurpleType:
        PURPLE_TYPE_UNKNOWN = 0
        PURPLE_TYPE_SUBTYPE
        PURPLE_TYPE_CHAR
        PURPLE_TYPE_UCHAR
        PURPLE_TYPE_BOOLEAN
        PURPLE_TYPE_SHORT
        PURPLE_TYPE_USHORT
        PURPLE_TYPE_INT
        PURPLE_TYPE_UINT
        PURPLE_TYPE_LONG
        PURPLE_TYPE_ULONG
        PURPLE_TYPE_INT64
        PURPLE_TYPE_UINT64
        PURPLE_TYPE_STRING
        PURPLE_TYPE_OBJECT
        PURPLE_TYPE_POINTER
        PURPLE_TYPE_ENUM
        PURPLE_TYPE_BOXED

    ctypedef enum PurpleSubType:
        PURPLE_SUBTYPE_UNKNOWN = 0
        PURPLE_SUBTYPE_ACCOUNT
        PURPLE_SUBTYPE_BLIST
        PURPLE_SUBTYPE_BLIST_BUDDY
        PURPLE_SUBTYPE_BLIST_GROUP
        PURPLE_SUBTYPE_BLIST_CHAT
        PURPLE_SUBTYPE_BUDDY_ICON
        PURPLE_SUBTYPE_CONNECTION
        PURPLE_SUBTYPE_CONVERSATION
        PURPLE_SUBTYPE_PLUGIN
        PURPLE_SUBTYPE_BLIST_NODE
        PURPLE_SUBTYPE_CIPHER
        PURPLE_SUBTYPE_STATUS
        PURPLE_SUBTYPE_LOG
        PURPLE_SUBTYPE_XFER
        PURPLE_SUBTYPE_SAVEDSTATUS
        PURPLE_SUBTYPE_XMLNODE
        PURPLE_SUBTYPE_USERINFO
        PURPLE_SUBTYPE_STORED_IMAGE
        PURPLE_SUBTYPE_CERTIFICATEPOOL

    ctypedef union __UnionTypeData:
        char char_data
        unsigned char uchar_data
        glib.gboolean boolean_data
        short short_data
        unsigned short ushort_data
        int int_data
        unsigned int uint_data
        long long_data
        unsigned long ulong_data
        glib.gint64 int64_data
        glib.guint64 uint64_data
        char *string_data
        void *object_data
        void *pointer_data
        int enum_data
        void *boxed_data

    ctypedef union __UnionTypeU:
        unsigned int subtype
        char *specific_type

    ctypedef struct PurpleValue:
        PurpleType type
        unsigned short flags
        __UnionTypeData data
        __UnionTypeU u
