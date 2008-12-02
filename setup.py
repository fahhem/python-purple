#!/usr/bin/env python

from distutils.core import setup
from distutils.extension import Extension

from Cython.Distutils import build_ext

from subprocess import Popen, PIPE

cflags = Popen(['pkg-config', '--cflags', 'purple'], stdout=PIPE).communicate()[0].split()
ldflags = Popen(['pkg-config', '--libs', 'purple'], stdout=PIPE).communicate()[0].split()

purplemodule = Extension('purple',
                         sources=['c_purple.c','purple.pyx'],
                         extra_compile_args=cflags,
                         extra_link_args=ldflags)

long_description = "\
Python bindings for libpurple, a multi-protocol instant messaging library."

class pypurple_build_ext(build_ext):
    def finalize_options(self):
        build_ext.finalize_options(self)
        self.include_dirs.insert(0, 'libpurple')
        self.pyrex_include_dirs.extend(self.include_dirs)

setup(name = 'python-purple',
      version = '0.1',
      author ='Bruno Abinader',
      author_email = 'bruno.abinader@openbossa.org',
      description = 'Python bindings for Purple',
      long_description = long_description,
      ext_modules = [purplemodule],
      cmdclass = {'build_ext': pypurple_build_ext},
      )
