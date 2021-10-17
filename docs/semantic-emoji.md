# Semantic Commit Messages with Emojis

Commit format: `<emoji_type> <commit_type>(<scope>): <subject>. <issue_reference>`

## Example
```
:sparkles: feat(Component): Add a new feature. Closes: #
^--------^ ^--^ ^-------^   ^---------------^  ^------^
|          |    |           |                  |
|          |    |           |                  +--> (Optional) Issue reference: if the commit closes or fixes an issue
|          |    |           |
|          |    |           +---------------------> Commit summary
|          |    |
|          |    +---------------------------------> (Optional) Commit scope in the project
|          |
|          +--------------------------------------> Commit type: feat, fix, docs, refactor, test, style, chore, build, perf or ci
|
+-------------------------------------------------> (Optional) Emoji type. See: https://gitmoji.carloscuesta.me/
```

**The commit message will be:**

> feat: Add a new feature

**With optional features emoji, scope and issue reference:**

> :sparkles: feat(Component): Add a new feature. Closes: #..

## Commit Message Types

### Default Devmoji Reference

}
```

### Default Devmoji Reference

| Emoji                  | Devmoji Code      | Description                                                                                                       |
| ---------------------- | ----------------- | ----------------------------------------------------------------------------------------------------------------- |
| :sparkles:             | `:feat:`          | **feat:** a new feature                                                                                           |
| :bug:                  | `:fix:`           | **fix:** a bug fix                                                                                                |
| :books:                | `:docs:`          | **docs:** documentation only changes                                                                              |
| :art:                  | `:style:`         | **style:** changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc) |
| :recycle:              | `:refactor:`      | **refactor:** a code change that neither fixes a bug nor adds a feature                                           |
| :zap:                  | `:perf:`          | **perf:** a code change that improves performance                                                                 |
| :rotating_light:       | `:test:`          | **test:** adding missing or correcting existing tests                                                             |
| :wrench:               | `:chore:`         | **chore:** changes to the build process or auxiliary tools and libraries such as documentation generation         |
| :rocket:               | `:chore-release:` | **chore(release):** code deployment or publishing to external repositories                                        |
| :link:                 | `:chore-deps:`    | **chore(deps):** add or delete dependencies                                                                       |
| :package:              | `:build:`         | **build:** changes related to build processes                                                                     |
| :construction_worker:  | `:ci:`            | **ci:** updates to the continuous integration system                                                              |
| :rocket:               | `:release:`       | code deployment or publishing to external repositories                                                            |
| :lock:                 | `:security:`      | Fixing security issues.                                                                                           |
| :globe_with_meridians: | `:localize:`          | Internationalization and localization.                                                                            |
| :boom:                 | `:breaking:`      | Introducing breaking changes.                                                                                     |
| :gear:                 | `:config:`        | Changing configuration files.                                                                                     |
| :cyclone:     | `:revert:`        | revert something                                                                                                  |

> example ouput:

```console
$ echo "feat: added a new feature :smile:" | devmoji --commit
feat: ✨ added a new feature 😄

$ echo "chore(release): 1.1.1" | devmoji --commit
chore(release): 🚀 1.1.1

$ echo "fix(security): upgraded lodash" | devmoji --commit
fix(security): 🐛 🔒 upgraded lodash
```

