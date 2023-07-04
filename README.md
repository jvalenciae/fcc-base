[Based on the Readme template defined in https://github.com/koombea/readme/edit/master/README.md]: text
# rails-repository-template

## Overview

This Repository should serve as a template for the default github configurations for Rails apps 

## Getting Started

## Installation

## Best Practices

## Environments

### Production
[Add a link and a description of this environment]: text

### UAT
[Add a link and a description of this environment]: text

### Staging
[Add a link and a description of this environment]: text

## Troubleshooting
[List and describe steps to help solving any known issue (E.g: Rollbacks, Certificates issues, etc).]: text

## Contributing

The `master` branch of this repository contains the latest stable source code for the production environment. This branch and the `develop` branch are protected to prevent those from being accidentally deleted. Force pushes are also disabled to enforce following the process described in the [Releasing](#releasing) section.

Please follow this steps for submitting any changes:

1. Create a new branch for any new feature.
2. Make sure you include tests for your changes.
3. When the feature is complete, create a pull request to the develop branch.

### Continuous Integration

When a pull requests is submitted to the `develop` branch the CI service will automatically run the tests and generate a new build for testing. A message will be posted to the team's slack channel.

For more information, see our [CONTRIBUTING](CONTRIBUTING.md) guide.

## Releasing

All releases to the main branches (`master` and `develop`) must be code reviewed and approved before being merged by the team's _Release Manager_ following this steps:

1. After a pull request is submitted, the developer must assign the teammates to make a code review.
2. Once the code review is finished and changes are approved, the _QA Analyst_ would be automatically(?) notified to do the smoke testing.
3. If all tests passes, and the _QA Analyst_ does not find any issue the code can be merged by the _Release Manager_.
4. When all the features planned for a release are done, the _Release Manager_ will be in charge of approving and merging the changes to the `master` branch.
5. The _QA Analyst_ must do a full regression test of the production environment to make sure the new changes did not affect any other functionality.

[NOTE: Each pull request must include the following checklist]: text

### Checklist

Add the [PULL_REQUEST_TEMPLATE](PULL_REQUEST_TEMPLATE.md) to your repo to use it as a template for every pull request.

### Continuous Integration

When a change is merged into the `develop` branch the CI service will automatically run the tests and generate a new build for staging. A message will be posted to the team's slack channel.

When a change is merged into the `master` branch the CI service will automatically run the tests and generate a new build for production. A message will be posted to the team's slack channel.


For more information, see our [RELEASING](RELEASING.md) guide.

## License

Copyright © 2022 Koombea®. All rights reserved.
