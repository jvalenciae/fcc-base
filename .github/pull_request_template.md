[Based on the Readme template defined in https://github.com/koombea/koombea_rails_best_practices/blob/develop/wiki/Sample%20PR%20Template.md]: text
## Background

### Associated Stories
[Add a Link and a description of the tickets related to the this PR]: text
[Jira [KOO-271]: Add active scope to user model](<link to Jira ticket>)

### Overview
[Describe the funcitonalities, fixes and improvements done in this PR]: text
* Add deleted_at field to users.
* Add scope to get list of active users.

### Visual Documentation
[Add Screenshot, GIFs or videos displaying the functionalities added]: text
[Describe how these are related to the functionalities if needed]: text
N/A

## Review

### QA Steps
[Describe the step to reproduce the acceptance criteria of the card]: text
[If needed, apply optional scenarios as well]: text
* [ ] Open a console.
  * [ ] Create user with deleted_at not nil.
  * [ ] Use scope to get active users. `User.active`
  * [ ] Check the user you just created is not in the list

## Deployment

### Environment variables Changes
[Describe the enviariables and or secrets that need to be added to the environments before or after the changes are deployed]: text
[Provide the values of the vars unless the data is private]: text
* [ ] Add the new env variable `USER_ACTIVE_SCOPE=true`

### Non-Code Changes
[Describe tasks that need to be run when the changes these changes are deployed to specific environments]: text
* Run data migration to update inactive users's deleted_at

### Other Notes

* I will need someone with access to the console to get this command run when this is deployed to prod.