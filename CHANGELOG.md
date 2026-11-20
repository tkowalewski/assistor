# Changelog

## 0.3.0

### Changed
* **Breaking:** require Ruby >= 3.2.
* Add `logger` as a runtime dependency.
* Assistant pid files are stored in a private `assistor-<uid>` directory under the system tmpdir instead of directly in it.

### Security
* Pid files and log files are created with `0600` permissions and never follow symlinks.
* The assistant runtime directory is verified to be owned by the current user and not accessible by others.

### Fixed
* `Assistant#assists?` handles `EPERM` and always returns a boolean.
* `PidFile#delete` ignores an already missing file.
* `Daemon` survives a failing exception handler and removes its pid file after a fatal error.

### Development
* Add specs, RuboCop, bundler-audit, Dependabot and GitHub Actions CI.
