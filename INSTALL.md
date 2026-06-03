# Installation and Usage Guide

This guide provides instructions for building, testing, and running the `libntrip-swift` project.

## Prerequisites

- **Swift 6.0 or later**: The project leverages modern Swift features like structured concurrency.
- **Operating System**: Linux (Ubuntu 22.04+ recommended) or macOS (13.0+).
- **Dependencies**: The project automatically manages dependencies via Swift Package Manager (SPM).

## Building the Project

To compile the project and its CLI tools, run the following command in the project root:

```bash
swift build
```

For a release build with optimizations:

```bash
swift build -c release
```

## Running the CLI Tools

After building, the executables are located in the `.build/debug/` (or `.build/release/`) directory.

### NTRIP Client

The client connects to an NTRIP Caster to receive GNSS correction data.

**Basic Usage:**
```bash
.build/debug/ntrip-client --host <caster_host> --port 2101 --mountpoint <mountpoint>
```

**With Authentication and RTCM3 Parsing:**
```bash
.build/debug/ntrip-client -h euref-ip.net -m BRUX00BEL0 -u myuser -P mypass -x
```

### NTRIP Server

The server pushes GNSS data from a local source to an NTRIP Caster.

**Basic Usage:**
```bash
.build/debug/ntrip-server --host <caster_host> --mountpoint <mountpoint> --password <source_pass> --input <file_path>
```

**Streaming from stdin:**
```bash
cat data.rtcm | .build/debug/ntrip-server -h mycaster.com -m MYMOUNT -p sourcepass
```

## Configuration via JSON

Both tools support loading configuration from a JSON file using the `--config` or `-c` flag.

**Example `config.json`:**
```json
{
  "host": "euref-ip.net",
  "port": 2101,
  "mountpoint": "BRUX00BEL0",
  "user": "myuser",
  "password": "mypassword",
  "logging": {
    "log_dir": "log/"
  }
}
```

**Run with config:**
```bash
.build/debug/ntrip-client --config config.json
```

## Running Tests

The project includes a comprehensive suite of unit tests for bit-level parsing, CRC calculation, and protocol utilities.

To run all tests:

```bash
swift test
```

To run a specific test suite:

```bash
swift test --filter BitReaderTests
```

## Generating Documentation

You can generate a local developer guide using Swift's DocC:

```bash
swift package generate-docc-reference
```

## Logging

Logs are generated with timestamps and stored in the directory specified in your configuration (defaults to `log/`). Each run creates a new file prefixed with the application name (e.g., `ntrip-client_20260601_223045.log`).
