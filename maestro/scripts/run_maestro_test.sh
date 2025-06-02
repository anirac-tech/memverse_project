#!/bin/bash

# Maestro Test Runner Script
# Based on patterns from NJWKotlinWebHostFlutterModuleNav
# Usage: ./run_maestro_test.sh [options] <test-name>

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage instructions
show_usage() {
    echo -e "${YELLOW}Usage:${NC}"
    echo "  $0 [options] <test-name>"
    echo ""
    echo -e "${YELLOW}Options:${NC}"
    echo "  -v, --video     Record video of test execution"
    echo "  -p, --play      Play/run an existing test flow"
    echo "  -c, --continuous Run in continuous mode (efficient for development)"
    echo "  -d, --device    Specify device ID for testing"
    echo "  -h, --help      Show this help message"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  $0 --play login            # Run the login test flow"
    echo "  $0 --video login           # Run login test and record video"
    echo "  $0 --continuous happy_path # Run happy path in continuous mode"
    echo "  $0 --play all              # Run all test flows"
    echo "  $0 --play happy_path --device emulator-5554  # Run on specific device"
    echo ""
    echo -e "${YELLOW}Continuous Mode Benefits:${NC}"
    echo "  • Faster test execution by reusing app state"
    echo "  • Automatic retry on failures"
    echo "  • Real-time feedback during development"
    echo "  • Ideal for iterative test development"
}

# Check if Maestro is installed
check_maestro() {
    if ! command -v maestro &> /dev/null; then
        echo -e "${RED}Error: Maestro is not installed${NC}"
        echo "Please install Maestro by running: curl -Ls \"https://get.maestro.mobile.dev\" | bash"
        exit 1
    fi
}

# Ensure the Flutter app is running for testing
ensure_app_running() {
    # Check if Flutter app is running
    if ! pgrep -f "flutter run" > /dev/null; then
        echo -e "${YELLOW}Starting Flutter app in development mode...${NC}"
        flutter run --flavor development --target lib/main_development.dart &
        sleep 20  # Wait for app to start
    fi
}

# Run a test flow with optional video recording and continuous mode
run_test() {
    local test_name=$1
    local record_video=$2
    local continuous_mode=$3
    local device_id=$4
    local flow_path="maestro/flows/${test_name}.yaml"
    
    if [ "$test_name" = "all" ]; then
        echo -e "${GREEN}Running all test flows...${NC}"
        for flow in maestro/flows/*.yaml; do
            echo -e "${YELLOW}Running flow: $(basename "$flow")${NC}"
            run_single_flow "$flow" "$record_video" "$continuous_mode" "$device_id"
        done
    else
        if [ ! -f "$flow_path" ]; then
            echo -e "${RED}Error: Test flow '$test_name' not found${NC}"
            echo -e "${YELLOW}Available flows:${NC}"
            ls maestro/flows/*.yaml 2>/dev/null | sed 's/maestro\/flows\///g' | sed 's/\.yaml//g' || echo "No flows found"
            exit 1
        fi
        echo -e "${GREEN}Running test flow: $test_name${NC}"
        run_single_flow "$flow_path" "$record_video" "$continuous_mode" "$device_id"
    fi
}

# Run a single flow with specified options
run_single_flow() {
    local flow_path=$1
    local record_video=$2
    local continuous_mode=$3
    local device_id=$4
    
    # Build maestro command
    local maestro_cmd="maestro test"
    
    # Add device specification if provided
    if [ ! -z "$device_id" ]; then
        maestro_cmd="$maestro_cmd --device $device_id"
        echo -e "${YELLOW}Using device: $device_id${NC}"
    fi
    
    # Add continuous flag for efficient development testing
    if [ "$continuous_mode" = "true" ]; then
        maestro_cmd="$maestro_cmd --continuous"
        echo -e "${YELLOW}Running in continuous mode for efficient development...${NC}"
    fi
    
    # Add video recording if requested
    if [ "$record_video" = "true" ]; then
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local flow_name=$(basename "$flow_path" .yaml)
        local video_file="maestro/videos/${flow_name}_${timestamp}.mp4"
        
        # Ensure videos directory exists
        mkdir -p maestro/videos
        
        echo -e "${YELLOW}Recording video to: $video_file${NC}"
        maestro_cmd="maestro test --record $video_file"
        
        # Add device if specified
        if [ ! -z "$device_id" ]; then
            maestro_cmd="$maestro_cmd --device $device_id"
        fi
        
        # Note: continuous mode and video recording may not be compatible
        if [ "$continuous_mode" = "true" ]; then
            echo -e "${YELLOW}Note: Continuous mode disabled for video recording${NC}"
        fi
    fi
    
    # Add the flow path
    maestro_cmd="$maestro_cmd $flow_path"
    
    echo -e "${YELLOW}Executing: $maestro_cmd${NC}"
    
    # Run the command
    if eval "$maestro_cmd"; then
        echo -e "${GREEN}✅ Flow completed successfully: $(basename "$flow_path")${NC}"
    else
        echo -e "${RED}❌ Flow failed: $(basename "$flow_path")${NC}"
        if [ "$continuous_mode" = "true" ]; then
            echo -e "${YELLOW}Continuous mode will retry automatically...${NC}"
        fi
        return 1
    fi
}

# Main script logic
main() {
    check_maestro
    
    local record_video="false"
    local continuous_mode="false"
    local device_id=""
    local test_name=""
    local mode=""
    
    # Parse command line arguments with proper device handling
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--video)
                record_video="true"
                mode="play"
                shift
                ;;
            -p|--play)
                mode="play"
                shift
                ;;
            -c|--continuous)
                continuous_mode="true"
                mode="play"
                echo -e "${GREEN}Continuous mode enabled for efficient development${NC}"
                shift
                ;;
            -d|--device)
                if [[ -n $2 && $2 != -* ]]; then
                    device_id="$2"
                    shift 2
                else
                    echo -e "${RED}Error: --device requires a device ID${NC}"
                    show_usage
                    exit 1
                fi
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            -*)
                echo -e "${RED}Error: Unknown option $1${NC}"
                show_usage
                exit 1
                ;;
            *)
                if [ -z "$test_name" ]; then
                    test_name="$1"
                else
                    echo -e "${RED}Error: Multiple test names specified${NC}"
                    show_usage
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Validate arguments
    if [ -z "$mode" ] || [ -z "$test_name" ]; then
        echo -e "${RED}Error: Missing required arguments${NC}"
        show_usage
        exit 1
    fi
    
    # Set environment variables for secure credential handling
    if [ -z "$MEMVERSE_USERNAME" ] || [ -z "$MEMVERSE_PASSWORD" ]; then
        echo -e "${YELLOW}Warning: MEMVERSE_USERNAME and MEMVERSE_PASSWORD not set${NC}"
        echo "Set environment variables for login flows:"
        echo "  export MEMVERSE_USERNAME=your_username@example.com"
        echo "  export MEMVERSE_PASSWORD=your_password"
    fi
    
    # Ensure the Flutter app is running
    ensure_app_running
    
    # Execute requested mode
    case $mode in
        play)
            run_test "$test_name" "$record_video" "$continuous_mode" "$device_id"
            ;;
    esac
}

# Run main function
main "$@"
