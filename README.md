# makefile-template
Generic and scalable makefile project

How to use this framework:
1. Decide on the name of your target. Let's say X.
   - Create/modify make/target/X.mk. Feel free to use make/target/t1.mk as example
   - Create directory ./src/X and copy there your source code
2. Decide on supported platforms. Let's say Y.
   - Create/modify make/platform/Y.mk. Feel free to use make/platform/x86.mk as example
3. Build your project:
   - make X                          # default config release, default platform x86
   - make X CFG=release/debug        # override config
   - make X PLATFORM=Y               # override platform
4. Clean your project:
   - make clean_X                    # default config release, default platform x86
   - make clean_X CFG=release/debug  # override config
   - make clean_X PLATFORM=Y         # override platform
5. Run your project: 
   - make run_X                      # default config release, default platform x86
   - make run_X CFG=release/debug    # override config
   - make run_X PLATFORM=Y           # override platform

Enjoy!
