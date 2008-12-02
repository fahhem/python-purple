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

cimport proxy

cdef class ProxyInfoType:

    cdef proxy.PurpleProxyType c_proxyinfotype

    def __init__(self):
        self.c_proxyinfotype = proxy.PURPLE_PROXY_NONE

    def USE_GLOBAL(self):
        self.c_proxyinfotype = proxy.PURPLE_PROXY_USE_GLOBAL
        return self

    def HTTP(self):
        self.c_proxyinfotype = proxy.PURPLE_PROXY_HTTP
        return self

    def SOCKS4(self):
        self.c_proxyinfotype = proxy.PURPLE_PROXY_SOCKS4
        return self

    def SOCKS5(self):
        self.c_proxyinfotype = proxy.PURPLE_PROXY_SOCKS5
        return self

    def USE_ENVVAR(self):
        self.c_proxyinfotype = proxy.PURPLE_PROXY_USE_ENVVAR
        return self

cdef class ProxyInfo:

    cdef proxy.PurpleProxyInfo *c_proxyinfo

    def __init__(self):
        self.c_proxyinfo = NULL

    def cnew(self):
        if self.c_proxyinfo == NULL:
            self.c_proxyinfo = proxy.c_purple_proxy_info_new()

    def set_type(self, ProxyInfoType type):
        if self.c_proxyinfo:
            proxy.c_purple_proxy_info_set_type(self.c_proxyinfo, type.c_proxyinfotype)

    def set_host(self, char *host):
        if self.c_proxyinfo:
            proxy.c_purple_proxy_info_set_host(self.c_proxyinfo, host)

    def set_port(self, int port):
        if self.c_proxyinfo:
            proxy.c_purple_proxy_info_set_port(self.c_proxyinfo, port)

    def set_username(self, char *username):
        if self.c_proxyinfo:
            proxy.c_purple_proxy_info_set_username(self.c_proxyinfo, username)

    def set_password(self, char *password):
        if self.c_proxyinfo:
            proxy.c_purple_proxy_info_set_password(self.c_proxyinfo, password)

