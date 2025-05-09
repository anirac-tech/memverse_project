# Logging Standards and Tools

This document outlines the logging standards and tools used in the Memverse project.

## AppLogger Overview

The Memverse project uses a custom logging utility called `AppLogger` that provides consistent
logging across all app flavors and ensures that logs are only output in debug mode. This utility
wraps the [logger](https://pub.dev/packages/logger) package.

### Basic Usage
