{% from "omnis/map.jinja" import omnis with context %}

# Downloads an omnis application installer if we need to run it
omnis_installer:
  file.managed:
    - name: /tmp/omnis_installer.dmg
    - source: {{ omnis.installer_source }}
    - source_hash: {{ omnis.installer_source_hash }}
    - makedirs: true
    - replace: false
    - prereq:
      - cmd: install_omnis_application

# Runs an omnis application installer if the application is not present
install_omnis_application:
  cmd.script:
    - source: salt://omnis/files/install_omnis.sh
    - template: jinja
    - context:
        application_directory: {{ omnis.application_directory }}
        installer_file: /tmp/omnis_installer.dmg
    - unless: test -d "/Applications/{{ omnis.application_directory }}"

# bin
omnis_bin:
  file.directory:
    - name: /Applications/{{ omnis.application_directory }}/Contents/MacOS/bin
    - makedirs: true
    - require:
      - cmd: install_omnis_application

# OmnisCLI bin
omniscli:
  cmd.run:
    - name: curl -L -o "/Applications/{{ omnis.application_directory }}/Contents/MacOS/bin/omniscli" https://github.com/suransys/omniscli/raw/master/bin/omniscli; chmod 755 "/Applications/{{ omnis.application_directory }}/Contents/MacOS/bin/omniscli"
    - require:
      - file: omnis_bin
    - require_in:
      - test: omnis

# Checkpoint we can use to require the runtime to be installed
omnis:
  test.nop:
    - require:
      - cmd: install_omnis_application

# vagrant user's Applications
vagrant_applications:
  file.directory:
    - name: /Users/vagrant/Applications
    - user: vagrant

# Copy in OmnisCI and HelloWorld
{% for app in ["OmnisCI", "HelloWorld"] %}
copy_{{ app }}:
  cmd.run:
    - name: cp -R "/Applications/{{ omnis.application_directory }}" "/Users/vagrant/Applications/{{ app }}.app"
    - unless: test -d "/Users/vagrant/Applications/{{ app }}.app"
    - require:
      - file: vagrant_applications
      - test: omnis

  {% set app_startup_path = "/Users/vagrant/Library/Application Support/Omnis/" + app + "/startup" %}

{{ app }}_startup:
  file.directory:
    - name: {{ app_startup_path }}
    - makedirs: true
    - user: vagrant

{{ app }}_omniscli.lbs:
  cmd.run:
    - name: curl -L -o "{{ app_startup_path }}/omniscli.lbs" https://github.com/suransys/omniscli/raw/master/lib/8.1/omniscli.lbs
    - unless: test -f "{{ app_startup_path }}/omniscli.lbs"
    - runas: vagrant

{{ app }}_omnistap.lbs:
  cmd.run:
    - name: curl -L -o "{{ app_startup_path }}/omnistap.lbs" https://github.com/suransys/omnistap/raw/master/lib/8.1/omnistap.lbs
    - unless: test -f "{{ app_startup_path }}/omnistap.lbs"
    - runas: vagrant
{% endfor %}

# OmnisCI
ci.lbs:
  cmd.run:
    - name: curl -L -o "/Users/vagrant/Library/Application Support/Omnis/OmnisCI/startup/ci.lbs" https://github.com/omnis-ci/ci.lbs/raw/master/lib/8.1/ci.lbs
    - unless: test -f "/Users/vagrant/Library/Application Support/Omnis/OmnisCI/startup/ci.lbs"
    - runas: vagrant
