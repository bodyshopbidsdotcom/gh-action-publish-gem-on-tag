#!/bin/sh -l
GITHUB_TOKEN=$1
OWNER=$2

if [[ -z "${GITHUB_TOKEN}" ]]; then
  echo "Github token not provided";
  exit 2;
fi
if [[ -z "${OWNER}" ]]; then
  echo "Missing owner";
  exit 2;
fi

git config --global --add safe.directory /github/workspace

echo "Verifying the version matches the gem version"
VERSION_TAG=$(echo $GITHUB_REF | cut -d / -f 3)
GEM_VERSION=$(ruby -e "require 'rubygems'; gemspec = Dir.entries('.').find { |file| file =~ /.*\.gemspec/ }; spec = Gem::Specification::load(gemspec); puts spec.version")
if [[ $VERSION_TAG != "v$GEM_VERSION" ]]; then
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
