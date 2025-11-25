# Part Three
## See All Tags
To list all tags:
```bash
git tag
```
To list a certain tag:
`git show v1.0.0`
## Creating Git Tag
v MAJOR . MINOR . PATCH
To create a tag:
`git tag -a v1.0.0 -m "Release version 1.0.0"`
To push a tag:
`git push origin v1.0.0`
## Workflow Trigger
```on:
  push:
    tags:
      - "v*.*.*"
```
Explanation: Pushing v1.2.0 -> workflow runs, pushing to main does not run, pull requests do not run.
## Workflow Steps
Checkout Repository:
`- uses: actions/checkout@v5`
Required so Dockerfile and web-content are available
Extract version metadata:
`- uses: docker/metadata-action@v5`
This action reads the git tag (e.g., v1.2.0) and outputs:
- latest
- 1 (major)
- 1.2 (major.minor)
Login to DockerHub:
```- uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_TOKEN }}
```
Uses same secrets created in part two.
Build and push Docker image:
```- uses: docker/build-push-action@v6
  with:
    context: .
    push: true
    tags: ${{ steps.meta.outputs.tags }}
```
Builds the image once and pushes it with multiple version tags.
## Values to Update for Other Repositories
- DockerHub repo name: jawing641/dadjokes -> change to your DockerHub repo
- DockerHub secrets: must add DOCKER USERNAME and DOCKER TOKEN
- Tag pattern: v*.*.* can be adjusted
- Build context: adjust if not in root
## Testing for Workflow Tasking
- Push a semantic version tag
`git tag -a v1.0.1 -m "Release 1.0.1"
git push origin v1.0.1`
- Go to GitHub Actions
  - Open Repository
  - Click Actions
  - Look for: "v1.0.1" 
- You should see a green check box indicating it was a success.
## How to Verify the Image Works
- Open your DockerHub repository, e.g. https://hub.docker.com/r/jawing641/dadjokes
- Check for new tags
  - latest
  - 1 (major)
  - 1.0 (major.minor)
  - 1.0.0 (optional full version tag)
## Verify that Image in DockerHub works
- Pull a versioned tag:
`docker pull jawing641/dadjokes:v1.0.2`
- Run it:
`docker run --rm -p 8080:80 jawing641/dadjokes:v1.0.2
- Visit in your browser:
`http://localhost:8080`
## Link to Repo
https://hub.docker.com/r/jawing641/dadjokes

## Part Three Sources
Link: https://git-scm.com/book/en/v2/Git-Basics-Tagging
used for: Git tagging

Link: https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax#onpush
used for: pushing tags

Link: https://semver.org/
used for: semantic versioning

Link: https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax#filter-pattern-cheat-sheet
used for: filter pattern

Link: https://github.com/docker/metadata-action
used for: generating tags using metadata-action

Link: https://github.com/docker/metadata-action#tags-input
Used for: metadata action

Link: https://github.com/docker/metadata-action#outputs
used for: describing how tags are generated
