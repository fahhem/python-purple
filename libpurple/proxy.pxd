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
    ctypedef enum PurpleProxyType:
        PURPLE_PROXY_USE_GLOBAL
        PURPLE_PROXY_NONE
        PURPLE_PROXY_HTTP
        PURPLE_PROXY_SOCKS4
        PURPLE_PROXY_SOCKS5
        PURPLE_PROXY_USE_ENVVAR

    ctypedef struct PurpleProxyInfo:
        char *host
        int   port
        char *username
        char *password

    PurpleProxyInfo *c_purple_proxy_info_new "purple_proxy_info_new" ()
    void c_purple_proxy_info_destroy "purple_proxy_info_destroy" \
            (PurpleProxyInfo *info)
    void c_purple_proxy_info_set_type "purple_proxy_info_set_type" \
            (PurpleProxyInfo *info, PurpleProxyType type)
    PurpleProxyType c_purple_proxy_info_get_type "purple_proxy_info_get_type" \
            (PurpleProxyInfo *info)
    void c_purple_proxy_info_set_host "purple_proxy_info_set_host" \
            (PurpleProxyInfo *info, char *host)
    void c_purple_proxy_info_set_port "purple_proxy_info_set_port" \
            (PurpleProxyInfo *info, int port)
    void c_purple_proxy_info_set_username "purple_proxy_info_set_username" \
            (PurpleProxyInfo *info, char *username)
    void c_purple_proxy_info_set_password "purple_proxy_info_set_password" \
            (PurpleProxyInfo *info, char *password)
