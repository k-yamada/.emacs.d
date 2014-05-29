task :default => :setup

def exec_cmd(cmd)
  p cmd
  p `#{cmd}`
end

task :setup do
  Dir.chdir "public_repos/org-mode/" do
    p `pwd`
    exec_cmd "git pull origin master"
  end

  if `gem list | grep rcodetools`.chomp == ""
    exec_cmd "gem install rcodetools"
  end
  
  #if [ ! -e "riece-8.0.0.tar.gz" ]; then
  #  wget http://dl.sv.gnu.org/releases/riece/riece-8.0.0.tar.gz
  #  tar zxvf riece-8.0.0.tar.gz
  #fi
  #cd riece-8.0.0
  #./configure --with-lispdir=~/.emacs.d/elisp
  #make
  #sudo make install
end
