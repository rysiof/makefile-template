#! /usr/bin/python
# MIT License
#
# Copyright (c) 2020 rysiof@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import sys
import os

seed = int(sys.argv[1]) # how many file
target = sys.argv[2]

os.system("mkdir src")
os.system("mkdir " + os.path.join("src", target))

template_h = """#ifndef DIR_{idx}_H
#define DIR_{idx}_H

#include "common.h"

void cc_{idx}();
void cpp_{idx}();
void cxx_{idx}();

#ifdef __cplusplus
extern "C" {{
#endif // __cplusplus

void c_{idx}();

#ifdef __cplusplus
}}
#endif // __cplusplus

#endif // DIR_{idx}_H
"""

template_cc = """#include <stdio.h>

#include "f_{idx}.h"
void {type}_{idx}()
{{
    printf("{type}_{idx}();\\n");
}}
"""

template_c = """#include <stdio.h>

#include "f_{idx}.h"
void c_{idx}()
{{
    printf("c_{idx}();\\n");

}}
"""

main_headers = ""
main_calls = "int main(){{\n"
main_ends = "}}"

for i in range(seed):
    dir = os.path.join("src", target, "dir_{idx}".format(idx=i))
    os.system("mkdir " + dir)
    f = open(os.path.join(dir, "f_{idx}.h".format(idx=i)), "w")
    f.write(template_h.format(idx=i));
    f.close()

    for t in ["cc", "cxx", "cpp"]:
        f = open(os.path.join(dir, "{type}_{idx}.{type}".format(type=t,idx=i)), "w")
        f.write(template_cc.format(idx=i, type=t));
        f.close()

    f = f = open(os.path.join(dir, "c_{idx}.c".format(idx=i)), "w")
    f.write(template_c.format(idx=i));
    f.close()

    main_headers += "#include \"dir_{idx}/f_{idx}.h\"\n".format(idx=i)

    for t in ["cc", "cxx", "cpp"]:
        main_calls += "\t{type}_{idx}();\n".format(idx=i, type=t)
    main_calls += "\tc_{idx}();\n".format(idx=i)

f = open(os.path.join("src", target, "main.cc"), "w")
f.write(main_headers + main_calls + main_ends)
f.close()

f = open(os.path.join("src", target, "common.h"), "w")
f.write("")
f.close()
