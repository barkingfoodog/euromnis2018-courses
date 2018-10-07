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
    - unless:
      - ls "/Applications/{{ omnis.application_directory }}"

# Checkpoint we can use to require the app to be installed
omnis:
  test.nop:
    - require:
      - cmd: install_omnis_application
