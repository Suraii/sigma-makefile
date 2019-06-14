# sigma-makefile
What should a Makefile do ? Compile ? Sigh.. This one can taunt you, create a basic architecture (including .gitignore), clean temps, and many other comming features

# how to use
Sigma will seek '.c' source files in the 'SRCDIRS' variable, (by default SRCDIRS = src), IT IS NOT RECURSIVE, if you want to use subdirs you can add them in SRCDIRS like that : SRCDIRS = src src/debug another_src src/debug/input. DO NOT ADD '/' at the end of dir names

