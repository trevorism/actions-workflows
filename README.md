# actions-workflows

Gradle based github actions. These are used by Trevorism projects to build, test, and deploy applications.

[Examples](/examples) shows how to invoke the common workflows

## App version

`pipeline.yml` and `deploy.yml` resolve the deployed App Engine version id in this order:

1. The `version` input, when the caller supplies one.
2. `appVersion` in the repo's `gradle.properties`, with dots converted to dashes (`1.2.3` becomes `1-2-3`).

If neither is present the deploy fails rather than guessing.

## PR environments

`pipeline.yml` deploys each pull request to its own non-promoted App Engine version named
`pr-<number>`, and deletes it when the PR closes.
