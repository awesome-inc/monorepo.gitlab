[![GitPitch](https://gitpitch.com/assets/badge.svg)](https://gitpitch.com/awesome-inc/hello.gitlab.monorepo/master)

# monorepo.gitlab

Scripts helping towards [Monorepo](https://medium.com/@maoberlehner/monorepos-in-the-wild-33c6eb246cb9) with [GitLab CI](https://docs.gitlab.com/ee/ci/yaml/).

Mostly adapted from workarounds given in [gitlab-ce/issues/19232](https://gitlab.com/gitlab-org/gitlab-ce/issues/19232).
Hopefully soon to be integrated into GitLab CI!

## How to use

Add as a submodule

```bash
git submodule add https://github.com/awesome-inc/monorepo.gitlab.git .monorepo.gitlab
```

and update your `.gitlab-ci.yml`.

- Add a `before` script to get the *last green commit* in Gitlab CI as `${LAST_COMMIT}`:

```yml
before_script:
    - .monorepo.gitlab/last_green_commit.sh
```

- Build your sub-component `foo` only when there are diffs in `./foo` since `${LAST_COMMIT}`

```yml
build-foo:
  # before
  script: build foo
  # after
  script: .monorepo.gitlab/build_if_changed.sh foo build foo
```

## Tips

Use [YAML anchors](http://blog.daemonl.com/2016/02/yaml.html#yaml-anchors-references-extend) to keep your jobs DRY.

Say your using [docker-compose](https://docs.docker.com/compose/) to orchestrate & build your services.

Your `docker-compose.yml` may look something like this

```yml
version: '3'
services:
  webapp:
    image: "${DOCKER_REGISTRY}/${REPO}/${PRODUCT}_webapp:${TAG}"
    build:
      context: ./webapp
  ...
```

And you build and push each service through a script `build.sh` which goes something like this

```bash
#!/bin/bash -ex
component=$1
docker-compose build ${component}
if [ "$CI_BUILD_REF_NAME" -ne "master" ]; then exit; fi
docker-compose push ${component}
```

This uses `docker-compose` to build the service specified on the command line as a tagged docker image.
If you are on `master` it pushes the built image right away to the specified registry.

Then, your jobs in `.gitlab-ci.yml` could look something like this

```yml
# Use yml anchors, to keep jobs DRY, cf.: https://docs.gitlab.com/ee/ci/yaml/#anchors
.build_template: &build_definition
  tags:
    - linux
    - docker
  stage: build
  script: .monorepo.gitlab/build_if_changed.sh ${CI_JOB_NAME} ./build.sh ${CI_JOB_NAME}

webapp:
  <<: *build_definition
```