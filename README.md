# generate-data
GitHub Action that generates Minecraft default resourcepack assets for a specified version.

[![Test Action](https://github.com/MinecraftPlayground/generate-data/actions/workflows/test_action.yml/badge.svg)](https://github.com/MinecraftPlayground/generate-data/actions/workflows/test_action.yml)

## Usage

```yaml
jobs:
  download-data:
    runs-on: ubuntu-latest
    steps:
      - name: 'Download assets to "./default_data"'
        id: download_data
        uses: MinecraftPlayground/generate-data@latest
        with:
          version: 1.21.2
          path: './default_data'
```

### Inputs

| Input                | Required? | Default                                                           | Description                                                                            |
| :------------------- | --------- | :---------------------------------------------------------------- | :------------------------------------------------------------------------------------- |
| `version`            | No        | `latest-release`                                                  | Minecraft version to generate assets for or one of `latest-release`/`latest-snapshot`. |
| `path`               | No        | `./default`                                                       | Relative path under `$GITHUB_WORKSPACE` to place the assets.                           |
| `api-url`            | No        | `https://piston-meta.mojang.com/mc/game/version_manifest_v2.json` | URL to the Minecraft manifest API.                                                     |

## License
The scripts and documentation in this project are released under the [GPLv3 License](./LICENSE).
