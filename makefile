linux:
	sudo mkdir -p /usr/local/lib/lua/5.3
	sudo mkdir -p /usr/local/share/lua/5.3
	cd lfpp/ && sudo make
	sudo cp src/lfastr.lua /usr/local/lib/lua/5.3
	mkdir lfrt
	cp src/lfar.lua lfrt
	lua targets/Linux.lua
	mkdir -p $(HOME)/.config/lfrt
	mkdir -p $(HOME)/.config/lfrt/lib
	mkdir -p $(HOME)/.config/lfrt/prg
	sudo cp -r lfrt /usr/local/share/lua/5.3
	sudo cp src/lfrtcl.lua $(HOME)/.config/lfrt
	sudo cp src/lfrt-bin-linux.sh /usr/bin/lfrt
	sudo chmod a+x /usr/bin/lfrt
	

linux-full:
	$(MAKE) linux
	echo "installing LFdev"
	cp lfdev/ref.lfar $(HOME)/.config/lfrt/prg/lfdev.lfar
	cp lfpk/ref.lfar $(HOME)/.config/lfrt/prg/lfpkm.lfar

clean:
	cd lfpp/ && make clean
	rm -r lfrt

clean-full:
	$(MAKE) clean

luafoxOS:
	mkdir -p /usr/local/lib/lua/5.3
	mkdir -p /usr/local/share/lua/5.3
	cd lfpp/ && make
	cp src/lfastr.lua /usr/local/lib/lua/5.3
	mkdir lfrt
	cp src/lfar.lua lfrt
	lua targets/Linux.lua
	mkdir -p $(HOME)/.config/lfrt
	mkdir -p $(HOME)/.config/lfrt/lib
	mkdir -p $(HOME)/.config/lfrt/prg
	cp -r lfrt /usr/local/share/lua/5.3
	cp src/lfrtcl.lua $(HOME)/.config/lfrt
	cp src/lfrt-bin-linux.sh /usr/bin/lfrt
	chmod a+x /usr/bin/lfrt
	cp lfdev/ref.lfar $(HOME)/.config/lfrt/prg/lfdev.lfar
	cp lfpk/ref.lfar $(HOME)/.config/lfrt/prg/lfpkm.lfar
