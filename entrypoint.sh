#!/bin/sh -l
GITHUB_TOKEN=$1
OWNER=$2
WORKING_DIR=$3

if [[ -z "${GITHUB_TOKEN}" ]]; then
  echo "Github token not provided";
  exit 2;
fi
if [[ -z "${OWNER}" ]]; then
  echo "Missing owner";
  exit 2;
fi

if [[ -n "${WORKING_DIR}" ]]; then
  echo "Changing to directory: ${WORKING_DIR}"
  if ! cd "./${WORKING_DIR}"; then
    echo "Failed to change to directory: ${WORKING_DIR}"
    exit 1
  fi
fi

git config --global --add safe.directory /github/workspace

echo "Verifying the version matches the gem version"
VERSION_TAG=$(echo $GITHUB_REF | cut -d / -f 3)
GEM_VERSION=$(ruby -e "require 'rubygems'; gemspec = Dir.entries('.').find { |file| file =~ /.*\.gemspec/ }; spec = Gem::Specification::load(gemspec); puts spec.version")
# pre release versions have a .pre. prefix after the minor version
# '1.2.3.pre.beta.4' -> '1.2.3-beta.4'
GEM_VERSION=${GEM_VERSION/.pre./-}

if [[ $VERSION_TAG != $GEM_VERSION ]]; then
  echo "Version tag does not match gem version"
  exit 2;
fi

echo "Setting up access to Github Package Registry"
mkdir -p ~/.gem
touch ~/.gem/credentials
chmod 600 ~/.gem/credentials
echo ":github: Bearer ${GITHUB_TOKEN}" >> ~/.gem/credentials

echo "Building the gem"
gem build *.gemspec
echo "Pushing the gem to Github Package Registry"
gem push --key github --host "https://rubygems.pkg.github.com/${OWNER}" *.gem
