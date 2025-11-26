# Project 4
Jacob Wing, wing.10@wright.edu

# AI Generation Notice
This project uses two html files and a css file under the directory ./web-content created by **ChatGPT**

## Prompt used:
"Create a dad joke themed website with a minimum of two HTML files and one CSS file."

# Project Overview
## Continuous Integration Project Overview
This project creates a Continuous Integration pipeline that automatically builds a Docker container image
for the "Dad Joke Central" web application. Everytime code is pushed to the main branch, GitHub Actions
builds the Docker image using the repo's Dockerfile and then pushes the image to DockerHub. CI pipeline
is used in Part 3: This implements version control.

## Tools Used
### Docker
Used to containerize the Dad Joke website
Builds container image, runs image locally, stores final images on DockerHub
### DockerHub
Public container used to store: latest container image, rebuilt images from CI
### GitHub Actions
Provides automation for the CI pipeline.
Triggers the workflow when code is pushed to main, authenticates to DockerHub using repo secrets,
builds the Docker image, and pushes the image to DockerHub automatically.
### Repository Secrets
Allow secure authentication to DockerHub without exposing credentials.
Two GitHub secrets: DOCKER USERNAME, DOCKER TOKEN

## Project Diagram
Created using **LucidCharts**
The diagram below shows the CI pipeline used in this project.

![Project Diagram](images/ScreenshotProj4-1.png)
# Part One
## Website content
This repository contains a website called "Dad Joke Central," all web content files are stored in
the `web-content/` folder:
- [`web-content/index.html`](web-content/index.html) – main homepage
- [`web-content/jokes.html`](web-content/jokes.html) – "Joke Vault" page
- [`web-content/style.css`](web-content/style.css) – shared styling for the site

## Dockerfile
The Dockerfile is stored at the root of this repository.

- [`Dockerfile`](Dockerfile)

The contents include:


```dockerfile
FROM httpd:2.4

COPY ./web-content/ /usr/local/apache2/htdocs/
```

Explanation:
- FROM httpd:2.4
  - Uses Apache HTTP Server 2.4 image as base. Image already includes web server.
- COPY ./web-content/ /usr/local/apache2/htdocs
  - Copies everything from web-content directory into Apache's default root inside the container.
    When the container starts, Apache immediately serves the "Dad Joke Central" site.

## Building the Image
From the root of this repository, run:
`docker build -t jawing641/dadjokes:latest .`
Replace "jawing641" with your username if you want to push the image to Dockerhub.
Explanation:
  - `docker build` - builds a docker image
  - `-t jawing/dadjokes:latest`
    - `jawing641` : my docker username
    - `dadjokes` : repository name for the project
    - `latest` : the tag, for version control
## Running a Container That Serves the Application
After building the image, run the container with:
docker run --rm -p 8080:80 jawing641/dadjokes:latest
Explanation:
  - `--rm` - automatically removes container after stopped
  - `-p 8080:80` maps port 8080 on the host to port 80 in the container (Apache listens on port 80)
  - `jawing641/dadjokes:latest` - the image built from this repository using my personal username.

## Part One Sources

Link: https://docs.docker.com/reference/cli/docker/container/run/#rm
Used for: help with flags in docker

Link: https://docs.docker.com/get-started/docker-concepts/building-images/build-tag-and-publish-an-image/
Used for: help with building, tagging an image

Link: https://docs.docker.com/reference/cli/docker/container/run/#name
Used for: naming docker image

Link: https://docs.docker.com/reference/cli/docker/container/run/#detach
Used for: using detached mode

# Part Two
## Configuring GitHub Secrets
GitHub Actions has to authenticate to DockerHub before it can push container images. In order to
provide this, the repository uses two secrets:
- `DOCKER_USERNAME`
- `DOCKER_TOKEN`

### Creating a Personal Access Token (PAT)
- Sign in to DockerHub
- Go to: Account Settings -> Personal access tokens
- Click "Generate new token"
- Give it a name such as "githubactions"
- Set the scope for the user options include:
  - Read, Write, Delete
- Copy the generated token

### Setting Secrets for Use
- Open GitHub Repository
- Go to: Settings -> Secrets and Variables -> Actions
- Click "New Repository Secret"
- Give it a name, then add two secrets:
  - Name: `DOCKER_USERNAME` | `(your dockerhub username) jawing641`
  - Name: `DOCKER_TOKEN` | (DockerHub PAT created above)

The secrets allow the workflow to log in without storing credentials in the repository.

## CI with GitHub Actions

A workflow file has been created at:
`.github/workflows/ci-dockerhub.yml`

### Github Actions
This workflow:
- Runs when commits are pushed to main
- Checks out the repository
- Authenticates to DockerHub using repository secrets
- Builds the Docker image using the Dockerfile
- Pushes the image to DockerHub under tag:latest

### Workflow Trigger
```on:
  push:
    branches:
      - main
```
Explanation:
- Only commits to main branch trigger the CI pipeline
- No pull requests
- No tags yet
### Workflow Steps
- First:
```- uses: actions/checkout@v5```
Explanation: Pulls repo content so workflow can access Dockerfile and web-content
- Second:
```- uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_TOKEN }}
```
Explanation: Uses DockerHub credentials stored in GitHub Secrets
- Third:
```- uses: docker/build-push-action@v6
  with:
    context: .
    push: true
    tags: jawing641/dadjokes:latest
```
Builds Docker image from Dockerfile in repository root.
Pushes to DockerHub under latest tag.
### Values to Update if Used Elsewhere
- ```jawing641/dadjokes:latest``` replace with their DockerHub username or repository name
- Branch name ``main`` Whatever default branch their repository uses
- GitHub Secrets: Must be re-created in their repository.
## Testing and Validating CI Pipeline
### Test for Workflow Tasking
How to test that the workflow ran successfully:
- Make a small change (ex: edit text in index.html)
- Commit and push to main:
```git add .
git commit -m "Test CI"
git push
```
- Go to your GitHub repository
- Click the "Actions" tab
- Verify that the workflow
  - Started automatically
  - Completed successfully (green checkmark)
### How to Verify Image Works
- Visit DockerHub repository:
  - mine is: https://hub.docker.com/r/jawing641/dadjokes
- Check latest tag timestamp
- Pull updated image
`docker pull jawing641/dadjokes:latest`
- Run the container:
`docker run --rm -p 8080:80 jawing641/dadjokes:latest`
- Open:
`http://localhost:8080`

## Part Two Sources

Link: https://docs.docker.com/security/access-tokens/
Used for: Dockerhub access tokens, configuration

Link: https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets
Used for: creating secrets, how github actions use ${{ secrets.NAME }}, security details,
correct steps for adding secrets

Link: https://github.com/actions/checkout
Used for: Setting up checkout

Link: https://github.com/docker/login-action
Used for: docker login using secrets

Link: https://github.com/docker/build-push-action
Used for: build push actions, and configuration

Link: https://docs.docker.com/get-started/workshop/02_our_app/
used for: accessing a container image

# Part Three
## See All Tags
To list all tags:
```bash
git tag
```
To list a certain tag:
`git show v1.0.0`
## Creating Git Tag
- v MAJOR . MINOR . PATCH
- To create a tag:
`git tag -a v1.0.0 -m "Release version 1.0.0"`
- To push a tag:
`git push origin v1.0.0`
## Workflow Trigger
```on:
  push:
    tags:
      - "v*.*.*"
```
Explanation: Pushing v1.2.0 -> workflow runs, pushing to main does not run, pull requests do not run.
## Workflow Steps
- Checkout Repository:
`- uses: actions/checkout@v5`
- Required so Dockerfile and web-content are available
- Extract version metadata:
`- uses: docker/metadata-action@v5`
- This action reads the git tag (e.g., v1.2.0) and outputs:
  - latest
  - 1 (major)
  - 1.2 (major.minor)
Login to DockerHub:
```- uses: docker/login-action@v3
  with:
   username: ${{ secrets.DOCKER_USERNAME }}
   password: ${{ secrets.DOCKER_TOKEN }}
```
- Uses same secrets created in part two.
- Build and push Docker image:
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
