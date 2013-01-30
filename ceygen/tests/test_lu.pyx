# -*- coding: utf-8 -*-
# Copyright (c) 2013 Matěj Laitl <matej@laitl.cz>
# Distributed under the terms of the GNU General Public License v2 or any
# later version of the license, at your option.

import numpy as np

from support import CeygenTestCase
cimport ceygen.lu as l


class TestLu(CeygenTestCase):

    def test_inv(self):
        x_np = np.array([[1., -1.], [2., -1.]])
        expected = np.array([[-1., 1.], [-2., 1.]])

        self.assertApproxEqual(l.inv(x_np), expected)
        out_np = np.empty((2, 2))
        out2 = l.inv(x_np, out_np)
        self.assertApproxEqual(out_np, expected)  # test that it actually uses out
        self.assertApproxEqual(out2, expected)

        cdef double[:, :] x = x_np
        self.assertApproxEqual(l.inv(x), expected)
        cdef double[:, :] out = np.empty((2, 2))
        out2 = l.inv(x, out)
        self.assertApproxEqual(out, expected)
        self.assertApproxEqual(out2, expected)

    def test_inv_badinput(self):
        x = 0.5 * np.eye(2)
        out = np.zeros((2, 2))
        for X in (x, None, np.array([1.]), np.array([[1.], [2.]])):
            for OUT in (out, None, np.empty(2), np.empty((3, 2))):
                if X is x and (OUT is out or OUT is None):
                    l.inv(X, OUT)  # this should be valid
                else:
                    with self.assertRaises(ValueError):
                        l.inv(X, OUT)  # this should be valid
