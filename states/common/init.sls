{% set user = salt['pillar.get']('civix:user') -%}

common-php-pkgs:
  pkgrepo.managed:
    - ppa: {{ salt['pillar.get']('civix:php:ppa') }}
  pkg.installed:
    - pkgs:
      - php5.6
      - php5.6-common
      - php5.6-cli

add-civix-user:
  user.present:
    - name: {{ user }}
    - fullname: {{ user }}
    - home: /srv/{{ user }}

config-dirs:
  file.directory:
    - names:
      - /srv/log
      - /srv/civix
      - /srv/config
      - /srv/certs
      - /srv/powerline-server-releases
      - /srv/powerline-server
    - user: {{ user }}
    - group: {{ user }}
    - dir_mode: 755

get-composer:
  cmd.run:
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer
    - cwd: /root/
    - env:
      - HOME: /root

install-composer:
  cmd.run:
    - name: mv /root/composer.phar /usr/local/bin/composer
    - cwd: /root/
    - onchanges:
      - cmd: get-composer

install-curl:
  pkg.installed:
    - pkgs:
      - curl
      - python-pip
      - git

install-gitpython:
  pip.installed:
    - name: gitpython

install-boto3:
  pip.installed:
    - name: boto3