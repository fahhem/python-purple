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

cdef extern from "libpurple/proxy.h":
    cdef struct PurpleProxyInfo

    ctypedef int PurpleProxyType
    PurpleProxyInfo *purple_proxy_info_new()
    void c_purple_proxy_info_set_type "purple_proxy_info_set_type" (PurpleProxyInfo *info, PurpleProxyType type)
    void c_purple_proxy_info_set_host "purple_proxy_info_set_host" (const_char_ptr host)
    void c_purple_proxy_info_set_port "purple_proxy_info_set_port" (const_char_ptr port)
