#!/usr/bin/env python
import sys
import os

from setuptools import setup, find_packages, Extension
from distutils.sysconfig import get_python_inc
from Cython.Distutils import build_ext

from subprocess import Popen, PIPE

cflags = Popen(['pkg-config', '--cflags', 'purple'], stdout=PIPE).communicate()[0].split()
ldflags = Popen(['pkg-config', '--libs', 'purple'], stdout=PIPE).communicate()[0].split()

class pypurple_build_ext(build_ext):
    def finalize_options(self):
        build_ext.finalize_options(self)
        self.include_dirs.insert(0, 'include')
        self.pyrex_include_dirs.extend(self.include_dirs)

setup(
  name = 'python-pypurple',
  version = '0.1',
  author ='Bruno Abinader',
  author_email='bruno.abinader@openbossa.org',
  cmdclass = {'build_ext': pypurple_build_ext},
  ext_modules=[Extension('purple',
              sources=['c_purple.c','purple.pyx'],
              extra_compile_args=cflags,
              extra_link_args=ldflags)])
