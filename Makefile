# OWASP ZAP Security Testing Makefile
# Author: Generated for security testing workflow
# Description: Automates OWASP ZAP security scans for web applications

# Default variables
URL ?= http://localhost:8080
CONTAINER_NAME := owasp-zap
IMAGE := zaproxy/zap-weekly
CONTEXT_DIR := $(shell pwd)/context
OUTPUT_DIR := $(shell pwd)/output
CONTEXT_FILE := /zap/context/sample.context
REPORT_FILE := zap-report.html

# Colors for output
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
RESET := \033[0m

.PHONY: help clean setup zap-weekly zap-full-scan zap-api-scan check-requirements

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "$(BLUE)OWASP ZAP Security Testing Makefile$(RESET)"
	@echo "$(YELLOW)Available targets:$(RESET)"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(YELLOW)Usage examples:$(RESET)"
	@echo "  make zap-weekly URL=https://example.com"
	@echo "  make zap-full-scan URL=https://example.com"
	@echo "  make setup  # Create required directories"

check-requirements: ## Check if required directories and files exist
	@echo "$(BLUE)Checking requirements...$(RESET)"
	@test -d "$(CONTEXT_DIR)" || (echo "$(RED)Context directory missing. Run 'make setup'$(RESET)" && exit 1)
	@test -d "$(OUTPUT_DIR)" || (echo "$(RED)Output directory missing. Run 'make setup'$(RESET)" && exit 1)
	@echo "$(GREEN)Requirements check passed$(RESET)"

setup: ## Create required directories for ZAP scans
	@echo "$(BLUE)Setting up OWASP ZAP workspace...$(RESET)"
	@mkdir -p "$(CONTEXT_DIR)"
	@mkdir -p "$(OUTPUT_DIR)"
	@echo "$(GREEN)Setup complete! Directories created:$(RESET)"
	@echo "  - $(CONTEXT_DIR)"
	@echo "  - $(OUTPUT_DIR)"

zap-weekly: check-requirements ## Run OWASP ZAP baseline scan (weekly image)
	@echo "$(BLUE)Starting OWASP ZAP baseline scan...$(RESET)"
	@echo "$(YELLOW)Target URL: $(URL)$(RESET)"
	@echo "$(YELLOW)Report will be saved to: $(OUTPUT_DIR)/$(REPORT_FILE)$(RESET)"
	docker run --name $(CONTAINER_NAME) -it --rm \
		-v "$(CONTEXT_DIR)":/zap/context \
		-v "$(OUTPUT_DIR)":/zap/wrk \
		$(IMAGE) zap-baseline.py \
		-t $(URL) \
		-n $(CONTEXT_FILE) \
		-r $(REPORT_FILE) \
		-I
	@echo "$(GREEN)Scan completed! Check $(OUTPUT_DIR)/$(REPORT_FILE) for results$(RESET)"

zap-full-scan: check-requirements ## Run OWASP ZAP full scan (more comprehensive)
	@echo "$(BLUE)Starting OWASP ZAP full scan...$(RESET)"
	@echo "$(YELLOW)Target URL: $(URL)$(RESET)"
	@echo "$(RED)Warning: Full scan may take significantly longer$(RESET)"
	docker run --name $(CONTAINER_NAME) -it --rm \
		-v "$(CONTEXT_DIR)":/zap/context \
		-v "$(OUTPUT_DIR)":/zap/wrk \
		$(IMAGE) zap-full-scan.py \
		-t $(URL) \
		-n $(CONTEXT_FILE) \
		-r $(REPORT_FILE) \
		-I
	@echo "$(GREEN)Full scan completed! Check $(OUTPUT_DIR)/$(REPORT_FILE) for results$(RESET)"

zap-api-scan: check-requirements ## Run OWASP ZAP API scan
	@echo "$(BLUE)Starting OWASP ZAP API scan...$(RESET)"
	@echo "$(YELLOW)Target URL: $(URL)$(RESET)"
	docker run --name $(CONTAINER_NAME) -it --rm \
		-v "$(CONTEXT_DIR)":/zap/context \
		-v "$(OUTPUT_DIR)":/zap/wrk \
		$(IMAGE) zap-api-scan.py \
		-t $(URL) \
		-n $(CONTEXT_FILE) \
		-r $(REPORT_FILE) \
		-I
	@echo "$(GREEN)API scan completed! Check $(OUTPUT_DIR)/$(REPORT_FILE) for results$(RESET)"

clean: ## Clean up output files and stop any running containers
	@echo "$(BLUE)Cleaning up...$(RESET)"
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true
	@rm -rf "$(OUTPUT_DIR)"/*.html "$(OUTPUT_DIR)"/*.json "$(OUTPUT_DIR)"/*.xml
	@echo "$(GREEN)Cleanup completed$(RESET)"

status: ## Show current workspace status
	@echo "$(BLUE)OWASP ZAP Workspace Status$(RESET)"
	@echo "Context directory: $(CONTEXT_DIR)"
	@echo "Output directory: $(OUTPUT_DIR)"
	@echo "Default URL: $(URL)"
	@echo "Docker image: $(IMAGE)"
	@echo ""
	@echo "$(YELLOW)Recent reports:$(RESET)"
	@ls -la "$(OUTPUT_DIR)"/*.html 2>/dev/null || echo "No reports found"
	@echo ""
	@echo "$(YELLOW)Running containers:$(RESET)"
	@docker ps --filter "name=$(CONTAINER_NAME)" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" || echo "No containers running"

