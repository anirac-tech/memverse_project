# Maestro Video Recording: Local vs Remote Comparison

## Overview

Maestro offers two recording modes for generating video demonstrations of test flows:

- **Local Recording** (Beta): `--local` flag
- **Remote Recording** (Default): Cloud-based rendering

## Local Recording (`--local`)

### Syntax

```bash
maestro record --local <flow_file> <output_file>
```

### Example

```bash
maestro record --local maestro/flows/manual_incorrect_login.yaml maestro_videos/login_test.mp4
```

### Advantages

- ✅ **Privacy & Security**: No data sent to external servers
- ✅ **Corporate Friendly**: Works in restricted environments
- ✅ **Full Control**: Local processing and storage
- ✅ **No Network Dependency**: Works offline
- ✅ **Custom Output Path**: Specify exact output location
- ✅ **No Data Leakage**: Sensitive app content stays local

### Disadvantages

- ⚠️ **Beta Status**: May have bugs or limited features
- ⚠️ **Resource Usage**: Uses local CPU/memory for rendering
- ⚠️ **Platform Differences**: Rendering quality may vary by OS
- ⚠️ **Limited Support**: Beta features have less documentation

## Remote Recording (Default)

### Syntax

```bash
maestro record <flow_file>
```

### Example

```bash
maestro record maestro/flows/manual_incorrect_login.yaml
```

### Advantages

- ✅ **Stable**: Production-ready, fully supported
- ✅ **High Quality**: Professional cloud rendering
- ✅ **No Local Resources**: Doesn't use local CPU/memory
- ✅ **Consistent**: Same quality across all platforms
- ✅ **Well Documented**: Full support and documentation

### Disadvantages

- ❌ **Privacy Concerns**: App screens sent to Maestro servers
- ❌ **Corporate Restrictions**: May violate security policies
- ❌ **Network Required**: Must have internet connection
- ❌ **No Custom Output**: Can't specify local output path
- ❌ **Data Exposure**: Sensitive content visible to third parties

## Recommendations

### For Corporate/Private Projects

**Use Local Recording (`--local`)**

- Keeps sensitive data secure
- Meets corporate security requirements
- No external dependencies
- Accept beta limitations for security benefits

### For Open Source/Public Projects

**Use Remote Recording (default)**

- Higher quality output
- More stable and reliable
- Better documentation and support
- No privacy concerns with public apps

## Implementation Examples

### Shell Script for Local Recording

```bash
#!/bin/bash
# Local recording function
record_local() {
    local flow_file="$1"
    local output_file="$2"
    
    if maestro record --local "$flow_file" "$output_file"; then
        echo "✅ Local recording successful: $output_file"
    else
        echo "❌ Local recording failed"
        return 1
    fi
}

# Usage
record_local "flows/login.yaml" "videos/login_$(date +%Y%m%d_%H%M%S).mp4"
```

### Shell Script for Remote Recording

```bash
#!/bin/bash
# Remote recording function
record_remote() {
    local flow_file="$1"
    
    if maestro record "$flow_file"; then
        echo "✅ Remote recording successful"
    else
        echo "❌ Remote recording failed"
        return 1
    fi
}

# Usage
record_remote "flows/login.yaml"
```

## Error Handling

### Local Recording Issues

- **Error**: "Local rendering failed"
    - **Solution**: Try without `--local` flag as fallback
    - **Check**: Ensure sufficient disk space and permissions

### Remote Recording Issues

- **Error**: "Network connection failed"
    - **Solution**: Check internet connection
    - **Alternative**: Use `--local` flag
- **Error**: "Upload failed"
    - **Solution**: Check file size limits
    - **Alternative**: Simplify test flow

## Configuration Tips

### Environment Variables

```bash
# Set default recording mode
export MAESTRO_RECORD_LOCAL=true  # Force local recording
export MAESTRO_VIDEO_QUALITY=high # Set quality preference
```

### Directory Structure

```
project/
├── maestro/
│   ├── flows/
│   └── scripts/
├── maestro_videos/
│   ├── local/      # Local recordings
│   └── remote/     # Remote recordings (if any)
└── maestro_screenshots/
```

## Best Practices

1. **For Corporate Environments**: Always use `--local`
2. **Test Both Modes**: Verify which works better for your setup
3. **Backup Strategy**: Keep both video and screenshots
4. **File Naming**: Use timestamps for unique names
5. **Clean Up**: Regularly remove old video files
6. **Documentation**: Document which mode works for your team

## Troubleshooting

### Common Issues

1. **Permission Errors**: Ensure write permissions to output directory
2. **Path Issues**: Use absolute paths for reliability
3. **Beta Instability**: Have fallback to remote recording
4. **Large Files**: Monitor disk space usage

### Debug Commands

```bash
# Check Maestro version
maestro --version

# Test with debug output
maestro record --debug-output=./debug --local flows/test.yaml video.mp4

# Verify output file
ls -la maestro_videos/
file maestro_videos/your_video.mp4
```