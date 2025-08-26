#!/bin/bash

# Simple DSL validator script
# This script performs basic validation of the Structurizr DSL file

DSL_FILE="src/main/resources/workspace.dsl"

echo "Validating Structurizr DSL file: $DSL_FILE"
echo "=========================================="

# Check if file exists
if [ ! -f "$DSL_FILE" ]; then
    echo "❌ Error: DSL file not found at $DSL_FILE"
    exit 1
fi

echo "✅ DSL file found"

# Basic syntax checks
echo ""
echo "Performing basic syntax validation..."

# Check for required sections
if grep -q "workspace" "$DSL_FILE"; then
    echo "✅ 'workspace' keyword found"
else
    echo "❌ Error: Missing 'workspace' keyword"
    exit 1
fi

if grep -q "model" "$DSL_FILE"; then
    echo "✅ 'model' section found"
else
    echo "❌ Error: Missing 'model' section"
    exit 1
fi

if grep -q "views" "$DSL_FILE"; then
    echo "✅ 'views' section found"
else
    echo "❌ Error: Missing 'views' section"
    exit 1
fi

# Check for basic structure
if grep -q "person" "$DSL_FILE"; then
    echo "✅ Person elements found"
fi

if grep -q "softwareSystem" "$DSL_FILE"; then
    echo "✅ Software system elements found"
fi

if grep -q "container" "$DSL_FILE"; then
    echo "✅ Container elements found"
fi

# Check for relationships
if grep -q "->" "$DSL_FILE"; then
    echo "✅ Relationships found"
fi

# Check for view definitions
if grep -q "systemContext\|container\|component\|dynamic\|deployment" "$DSL_FILE"; then
    echo "✅ View definitions found"
fi

echo ""
echo "🎉 Basic validation completed successfully!"
echo ""
echo "Note: This is a basic validation. For full validation and JSON export,"
echo "you'll need to install a JDK (Java Development Kit) and run the Java application."
echo ""
echo "To install a JDK on macOS, you can:"
echo "1. Download from Oracle: https://www.oracle.com/java/technologies/downloads/"
echo "2. Or install Homebrew and run: brew install openjdk@11"
echo ""
echo "Your DSL file appears to be structurally correct!"
