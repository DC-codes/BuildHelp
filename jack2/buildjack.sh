#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Script to build jack2 on windows with Msys2 Mingw64 environment
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#- Upgrade base MSYS2 packages
echo ====================================================================================
echo "UPDATING PACKS"
echo ====================================================================================

pacman -Suy

#- Install required packages
echo ====================================================================================
echo " Installing required packages "
echo " Installing tool chain. select all by pressing Enter key"
echo ====================================================================================

pacman -Su mingw-w64-x86_64-toolchain 

echo ====================================================================================
echo " Installing other items"
echo ====================================================================================

pacman -Su patch autoconf make gettext-devel automake libtool p7zip unzip git python
pacman -Su pkgconfig

#install dependencies
echo ====================================================================================
echo "Installing dependencies"
echo ====================================================================================
pacman -Su  mingw-w64-x86_64-db				\
			mingw-w64-x86_64-libsndfile		\
			mingw-w64-x86_64-libsamplerate	\
			mingw-w64-x86_64-libtre-git		\
			mingw-w64-x86_64-libsystre		\
			mingw-w64-x86_64-portaudio

#clone jack2
echo ====================================================================================
echo "Cloning jack2"
echo ====================================================================================

if [ ! -d ~/jack2 ];
then
	git clone https://github.com/jackaudio/jack2
fi

# If /opt does not exist, create it
if [ ! -d /opt ];
then
	mkdir /opt 
fi

echo ====================================================================================
echo "Getting ASIO"
echo ====================================================================================
# If ASIOsdk does not exist, download and copy it to /opt/
if [ ! -d /opt/asiosdk ];
then
	wget https://www.steinberg.net/asiosdk -O /tmp/asiosdk.zip
	unzip /tmp/asiosdk.zip -d /tmp
	mv /tmp/asiosdk_2.3.3_2019-06-14  /opt/asiosdk
fi

#configure jack.
echo ====================================================================================
echo " Configuring jack2."
echo  "Due to waf script issue, you may need to press ctrl+ C after config finished msg"
echo " Like 'configure' finished successfully (16.383s) "
echo ====================================================================================

cd jack2
./waf configure --prefix=/opt/jack --debug

#build jack
echo ====================================================================================
echo " Building jack2."
echo ====================================================================================
./waf build

#Install (in /opt/jack/bin)
#./waf install
