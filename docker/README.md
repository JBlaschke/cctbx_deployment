# Instructions for Docker


These are instructions specific to deploying/using docker on different systems.

## Installation

### MacOS

Based on [this][1] article. The TL;DR version is:


1. Install all the software with homebrew:
```
brew install docker
brew install docker-machine
brew cask install virtualbox
```

2. Build docker VM (using vritualbox):
```
docker-machine create --driver virtualbox default
```

## Managing Docker Machines (MacOS)

1. Check docker status:
```
docker-machine ls
```

2. Start/Stop docker machine:
```
docker-machine <start/stop> default
```

3. Docker environment helper functions:
```
source env.fish
```
will configure the `docker-env` and `docker-unenv` helper functions. They set
(and unset) the environment variables pointing to the default docker machine.


[1]: https://medium.com/@yutafujii_59175/a-complete-one-by-one-guide-to-install-docker-on-your-mac-os-using-homebrew-e818eb4cfc3
