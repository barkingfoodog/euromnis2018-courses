jenkins:
  pkg.installed:
    - require:
      - cmd: java8

register_jenkins_service:
  cmd.run:
    - name: brew services start jenkins
    - runas: vagrant
    - require:
      - pkg: jenkins

build_lbs.sh:
  file.managed:
    - name: /Users/vagrant/Documents/build_lbs.sh
    - source: salt://jenkins/files/build_lbs.sh
    - mode: 755
    - user: vagrant