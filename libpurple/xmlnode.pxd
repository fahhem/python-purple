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

cdef extern from *:
    ctypedef int size_t

cdef extern from "libpurple/xmlnode.h":
    ctypedef struct xmlnode

    ctypedef enum XMLNodeType:
        XMLNODE_TYPE_TAG
        XMLNODE_TYPE_ATTRIB
        XMLNODE_TYPE_DATA

    ctypedef struct xmlnode:
        char *name
        char *xmlns
        XMLNodeType type
        char *data
        size_t data_sz
        xmlnode *parent
        xmlnode *child
        xmlnode *lastchild
        xmlnode *next
        char *prefix
        glib.GHashTable *namespace_map

    xmlnode *xmlnode_get_child(xmlnode *parent, char *name)
    char *xmlnode_to_str(xmlnode *node, int *len)
    char *xmlnode_get_data(xmlnode *node)
    char *xmlnode_get_attrib(xmlnode *node, char *attr)
