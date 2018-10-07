java8:
  cmd.run:
    - name: brew cask install homebrew/cask-versions/java8
    - unless: brew cask list | grep java8
    - runas: vagrant