#!/bin/bash

# Maestro Test Runner with Video Recording
# Based on: https://github.com/njwandroid/NJWKotlinWebHostFlutterModuleNav/blob/main/maestro/scripts/run_maestro_test.sh
# Created: 2025-05-31

set -e

# Configuration
APP_ID="com.spiritflightapps.memverse"
FLOWS_DIR="maestro/flows"
VIDEOS_DIR="maestro_videos"
SCREENSHOTS_DIR="maestro_screenshots"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create directories
create_directories() {
    mkdir -p "$VIDEOS_DIR"
    mkdir -p "$SCREENSHOTS_DIR"
    log_info "Created output directories"
}

# Check if device is available
check_device() {
    local device_count=$(adb devices | grep -v "List of devices" | grep "device" | wc -l)
    if [ $device_count -eq 0 ]; then
        log_error "No Android devices connected"
        exit 1
    fi
    log_success "Found $device_count Android device(s)"
}

# Launch app manually (safer than maestro launch)
launch_app() {
    log_info "Launching app manually..."
    adb shell am start -n "$APP_ID/.MainActivity"
    sleep 3
    log_success "App launched"
}

# Run test with recording
run_test_with_recording() {
    local flow_file="$1"
    local test_name=$(basename "$flow_file" .yaml)
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local video_file="${VIDEOS_DIR}/${test_name}_${timestamp}.mp4"
    
    log_info "Running test: $test_name"
    log_info "Recording to: $video_file"
    
    # Run maestro record command
    if maestro record "$flow_file" --output "$video_file"; then
        log_success "Test completed successfully"
        log_success "Video saved: $video_file"
        return 0
    else
        log_error "Test failed"
        return 1
    fi
}

# Run test without recording (fallback)
run_test_only() {
    local flow_file="$1"
    local test_name=$(basename "$flow_file" .yaml)
    
    log_info "Running test without recording: $test_name"
    
    if maestro test "$flow_file"; then
        log_success "Test completed successfully"
        
        # Copy screenshots if available
        local latest_test_dir=$(ls -1t ~/.maestro/tests/ | head -n 1)
        if [ -n "$latest_test_dir" ]; then
            cp ~/.maestro/tests/"$latest_test_dir"/*.png "$SCREENSHOTS_DIR/" 2>/dev/null || true
            log_info "Screenshots copied to $SCREENSHOTS_DIR"
        fi
        return 0
    else
        log_error "Test failed"
        return 1
    fi
}

# Main function
main() {
    local flow_file=""
    local record_video=true
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --flow)
                flow_file="$2"
                shift 2
                ;;
            --no-record)
                record_video=false
                shift
                ;;
            --help|-h)
                echo "Usage: $0 --flow <yaml_file> [--no-record]"
                echo ""
                echo "Options:"
                echo "  --flow <file>     Maestro flow file to run"
                echo "  --no-record       Run test without video recording"
                echo "  --help, -h        Show this help message"
                echo ""
                echo "Examples:"
                echo "  $0 --flow flows/incorrect_login.yaml"
                echo "  $0 --flow flows/manual_incorrect_login.yaml --no-record"
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Validate arguments
    if [ -z "$flow_file" ]; then
        log_error "Flow file is required. Use --flow <yaml_file>"
        exit 1
    fi
    
    if [ ! -f "$flow_file" ]; then
        log_error "Flow file not found: $flow_file"
        exit 1
    fi
    
    # Setup
    create_directories
    check_device
    launch_app
    
    # Run test
    if [ "$record_video" = true ]; then
        if ! run_test_with_recording "$flow_file"; then
            log_warning "Recording failed, trying without recording..."
            run_test_only "$flow_file"
        fi
    else
        run_test_only "$flow_file"
    fi
}

# Run main function with all arguments
main "$@"