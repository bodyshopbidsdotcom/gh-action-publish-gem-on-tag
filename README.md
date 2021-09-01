# Publish Ruby Gem to GitHub Package Registry On Tag
This Github action builds the `.gemspec` file in the project's root directory and uploads it to [The Github Package Registry](https://github.com/features/packages). It fires the action in response to pushes of version tags to the repository with the format `*.*.*`, and includes validation that the tagged version matches the `.gemspec` version.

## Usage
In your `.github/workflows` directory add the job file, and ensure it only runs for tag pushes in the format `'*.*.*'`

```yaml
name: Build and Publish Ruby Gem on Tag Pushes
on:
  push:
    tags:
      - '*.*.*'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: Build and Publish Ruby Gem on Tag Pushes
      uses: bodyshopbidsdotcom/gh-action-publish-gem-on-tag@<latest_release_version>
      with:
        token: ${{ secrets.GITHUB_TOKEN }}
        owner: bodyshopbidsdotcom
```
