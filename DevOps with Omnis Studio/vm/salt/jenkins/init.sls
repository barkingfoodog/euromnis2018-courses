jenkins:
  pkg.installed:
    - require:
      - cmd: java8

register_jenkins_service:
  cmd.run:
    - name: brew services start jenkins
    - runas: vagrant
    - onchanges:
      - pkg: jenkins