
## Initial setup

Copy and fill the environment file
```bash
cp scripts/.env.template scripts/.env
```

## Bump build number

1. Update version in `Config/project.xcconfig`
2. Commit the changes
```bash
git add -u
BUILD_NUMBER=$(grep "CURRENT_PROJECT_VERSION" Config/project.xcconfig | cut -d' ' -f 3)
MARKETING_VERSION=$(grep "MARKETING_VERSION" Config/project.xcconfig | cut -d' ' -f 3)
git commit -m "Bump version to $MARKETING_VERSION ($BUILD_NUMBER)"
git tag "$MARKETING_VERSION"
```

## Release app

1. Build & Sign application
```bash
source scripts/.env
./scripts/distribute.sh
```

2. Push commits to GitHub
```bash
git push
git push --tags
```

3. Create the release on GitHub:
	- Fill with contents from CHANGELOG.md
	- Add the artefact `release.zip`
