package = "bm3d"
version = "scm-1"

source = {
   url = "git://github.com/soumith/bm3d.torch",
   tag = "master"
}

description = {
   summary = "bm3d for torch",
   detailed = [[
   	    bm3d.
   ]],
   homepage = "https://google.com"
}

dependencies = {
   "torch >= 7.0"
}

build = {
   type = "command",
   build_command = [[
cmake -E make_directory build;
cd build;
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$(LUA_BINDIR)/.." -DCMAKE_INSTALL_PREFIX="$(PREFIX)";
$(MAKE)
   ]],
   install_command = "cd build && $(MAKE) install"
}
