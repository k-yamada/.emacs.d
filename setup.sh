gem install rcodetools

wget http://dl.sv.gnu.org/releases/riece/riece-8.0.0.tar.gz
tar zxvf riece-8.0.0.tar.gz
cd riece-8.0.0
./configure CC="gcc -arch i386 -arch x86_64 -arch ppc -arch ppc64" \
            CXX="g++ -arch i386 -arch x86_64 -arch ppc -arch ppc64" \
            CPP="gcc -E" CXXCPP="g++ -E" --with-lispdir=~/.emacs.d/elisp
make
sudo make install

