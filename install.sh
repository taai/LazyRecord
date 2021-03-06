#!/bin/bash
os=$(uname)
install_pgsql=Y
install_sqlite=Y
install_mysql=Y

read -p "Install php-sqlite? (Y/n)" install_sqlite
read -p "Install php-pgsql? (Y/n)" install_pgsql
read -p "Install php-mysql? (Y/n)" install_mysql


onion=$(which onion)

if [[ ! -e $onion ]] ; then
    echo "Onion is not found, Installing Onion..."
    curl -L -s http://install.onionphp.org/ | bash
fi

echo "Installing dependencies..."
if [[ $os == "Darwin" ]] ; then
    port=$(which port)
    brew=$(which brew)
    if [[ -e $port ]] ; then
        sudo $port -q install php5-yaml
        if [[ $install_mysql != 'n' ]]  ; then sudo $port -q install php5-mysql      ; fi
        if [[ $install_sqlite != 'n' ]] ; then sudo $port -q install php5-sqlite     ; fi
        if [[ $install_pgsql != 'n' ]]  ; then sudo $port -q install php5-postgresql ; fi
    elif [[ -e $brew ]] ; then
        brew install libyaml 
        pecl install -f yaml
        echo "brew install: not supported yet"
    fi
elif [[ $os == "Linux" ]] ; then
    apt=$(which apt-get)
    if [[ -e $apt ]] ; then
        sudo $apt -qq install -y php5-dev
        sudo $apt -qq install -y php5-cli
        sudo $apt -qq install -y php5-yaml
        if [[ $install_mysql != 'n' ]]  ; then sudo $apt -qq install -y php5-mysql      ; fi
        if [[ $install_sqlite != 'n' ]] ; then sudo $apt -qq install -y php5-sqlite     ; fi
        if [[ $install_pgsql != 'n' ]]  ; then sudo $apt -qq install -y php5-pgsql      ; fi
    fi
fi

mkdir -p /tmp
cd /tmp
pear channel-discover pear.twig-project.org
pear channel-discover pear.corneltek.com
if [[ ! -e LazyRecord ]] ; then
    git clone --quiet git://github.com/c9s/LazyRecord.git
    cd LazyRecord
else
    cd LazyRecord
    git pull --quiet origin master
fi

echo "Installing LazyRecord..."
pear install -a -f package.xml

echo "LazyRecord is installed, please run 'lazy' to start."
lazy --version
