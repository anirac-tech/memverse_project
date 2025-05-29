#!/bin/bash

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
    echo "  -r, --record    Record a new test flow"
    echo "  -p, --play      Play/run an existing test flow"
    echo "  -h, --help      Show this help message"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  $0 --record login          # Record a new login test flow"
    echo "  $0 --play login            # Run the login test flow"
    echo "  $0 --play all             # Run all test flows"
}

# Check if Maestro is installed
check_maestro() {
    if ! command -v maestro &> /dev/null; then
        echo -e "${RED}Error: Maestro is not installed${NC}"
        echo "Please install Maestro by running: curl -Ls \"https://get.maestro.mobile.dev\" | bash"
        exit 1
    fi
}

# Ensure the Flutter app is running for recording/playing tests
ensure_app_running() {
    # Check if Flutter app is running
    if ! pgrep -f "flutter run" > /dev/null; then
        echo -e "${YELLOW}Starting Flutter app in development mode...${NC}"
        flutter run --flavor development &
        sleep 20  # Wait for app to start
    fi
}

# Record a new test flow
record_test() {
    local test_name=$1
    local flow_path="maestro/flows/${test_name}.yaml"
    
    if [ -f "$flow_path" ]; then
        echo -e "${YELLOW}Warning: Test flow '$test_name' already exists${NC}"
        read -p "Do you want to overwrite it? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${RED}Recording cancelled${NC}"
            exit 1
        fi
    fi
    
    echo -e "${GREEN}Recording test flow: $test_name${NC}"
    echo -e "${YELLOW}Please interact with your app now. Press Ctrl+C when done.${NC}"
    
    maestro record -f "$flow_path"
}

# Run a test flow
run_test() {
    local test_name=$1
    local flow_path="maestro/flows/${test_name}.yaml"
    
    if [ "$test_name" = "all" ]; then
        echo -e "${GREEN}Running all test flows...${NC}"
        for flow in maestro/flows/*.yaml; do
            echo -e "${YELLOW}Running flow: $(basename "$flow")${NC}"
            maestro test "$flow"
        done
    else
        if [ ! -f "$flow_path" ]; then
            echo -e "${RED}Error: Test flow '$test_name' not found${NC}"
            exit 1
        fi
        echo -e "${GREEN}Running test flow: $test_name${NC}"
        maestro test "$flow_path"
    fi
}

# Main script logic
main() {
    check_maestro
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -r|--record)
                MODE="record"
                shift
                ;;
            -p|--play)
                MODE="play"
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                TEST_NAME="$1"
                shift
                ;;
        esac
    done
    
    # Validate arguments
    if [ -z "$MODE" ] || [ -z "$TEST_NAME" ]; then
        show_usage
        exit 1
    fi
    
    # Ensure the Flutter app is running
    ensure_app_running
    
    # Execute requested mode
    case $MODE in
        record)
            record_test "$TEST_NAME"
            ;;
        play)
            run_test "$TEST_NAME"
            ;;
    esac
}

main "$@"